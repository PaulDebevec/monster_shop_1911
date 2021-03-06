require 'rails_helper'

RSpec.describe("Order Creation") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      default_user = User.create({
        name: "Paul D",
        address: "123 Main St.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "pauld@gmail.com",
        password: "supersecure1",
        role: 0
        })


      visit "/login"
      fill_in :email, with: default_user[:email]
      fill_in :password, with: "supersecure1"
      click_button "Sign In"

      order_1 = default_user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      visit "/cart"
      click_on "Checkout"
    end

    it 'I can create a new order' do

      click_link "Logout"

      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)


      default_user = User.create({
        name: "example_name",
        address: "123 Main St.",
        city: "Broomfield",
        state: "CO",
        zip: "80020",
        email: "blarggg@example.com",
        password: "password",
        role: 0
        })

      order_1 = default_user.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      visit "/login"

      fill_in :email, with: "blarggg@example.com"
      fill_in :password, with: "password"
      click_button "Sign In"

      visit "/items/#{paper.id}"
      click_on "Add To Cart"
      visit "/items/#{pencil.id}"
      click_on "Add To Cart"

      visit "/cart"

      click_on "Checkout"


      within "#order-item-#{paper.id}" do
        expect(page).to have_link(paper.name)
        expect(page).to have_link("#{paper.merchant.name}")
        expect(page).to have_content("$#{paper.price}")
        expect(page).to have_content("2")
        expect(page).to have_content("$20")
      end

      within "#order-item-#{pencil.id}" do
        expect(page).to have_link(pencil.name)
        expect(page).to have_link("#{pencil.merchant.name}")
        expect(page).to have_content("$#{pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      expect(page).to have_content("Total: $22")


      fill_in :name, with: "Bert"
      fill_in :address, with: "123 Sesame St."
      fill_in :city, with: "NYC"
      fill_in :state, with: "New York"
      fill_in :zip, with: 10001

      click_on "Create Order"

      expect(current_path).to eq("/profile/orders")
    end

    it 'i cant create order if info not filled out' do
      name = ""
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_button "Create Order"

      expect(page).to have_content("Please complete address form to create an order.")
      expect(page).to have_button("Create Order")
    end
  end
end
