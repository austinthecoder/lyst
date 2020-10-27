RSpec.describe Lyst do
  it "manages checklists" do
    app = Lyst.start

    app.add_item("Do laundry")
    app.add_item("Cook dinner")

    items = app.get_items

    app.check_item(items[0])

    expect(app.get_items.size).to eq(2)

    expect(app.get_items[0].name).to eq("Do laundry")
    expect(app.get_items[0].checked?).to eq(true)

    expect(app.get_items[1].name).to eq("Cook dinner")
    expect(app.get_items[1].checked?).to eq(false)
  end
end
