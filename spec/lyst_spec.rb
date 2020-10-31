RSpec.describe Lyst do
  it "manages checklists" do
    app = Lyst.start

    app.add_item("Do laundry")
    app.add_item("Cook dinner")

    items = app.get_items
    app.check_item(items[0])

    items = app.get_items
    expect(items.size).to eq(2)

    expect(items[0].name).to eq("Do laundry")
    expect(items[0].checked?).to eq(true)

    expect(items[1].name).to eq("Cook dinner")
    expect(items[1].checked?).to eq(false)
  end

  it "reprocesses events" do
    app = Lyst.start

    app.add_item("Do laundry")
    app.add_item("Cook dinner")

    items = app.get_items
    app.check_item(items[0])

    app.clear_state

    expect(app.get_items).to eq([])

    app.restore_state

    items = app.get_items
    expect(items.size).to eq(2)

    expect(items[0].name).to eq("Do laundry")
    expect(items[0].checked?).to eq(true)

    expect(items[1].name).to eq("Cook dinner")
    expect(items[1].checked?).to eq(false)
  end
end
