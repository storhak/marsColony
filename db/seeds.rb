# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


multi = Type.create :name => "multiplier"
energy = Type.create :name => "energyCap"
cost = Type.create :name => "uraniumCost"

iron = Resource.create :name => "iron"
tin = Resource.create :name => "tin"
copper = Resource.create :name => "copper"
uranium = Resource.create :name => "uranium"

Upgrade.create :name => "Mining I", :description => "Increase current mining amount: X2.", :cost => 500, :value => 2, :type_id => multi.id
Upgrade.create :name => "Mining II", :description => "Increase current mining amount: X3.", :cost => 5000, :value => 3, :type_id => multi.id
Upgrade.create :name => "Mining III", :description => "Increase current mining amount: X4.", :cost => 50000, :value => 4, :type_id => multi.id
Upgrade.create :name => "Mining IV", :description => "Increase current mining amount: X5.", :cost => 500000, :value => 5, :type_id => multi.id
Upgrade.create :name => "Energy I", :description => "Increase current energy capacity: X2.", :cost => 500, :value => 2, :type_id => energy.id
Upgrade.create :name => "Energy II", :description => "Increase current energy capacity: X2.", :cost => 5000, :value => 2, :type_id => energy.id
Upgrade.create :name => "Energy III", :description => "Increase current energy capacity: X2.", :cost => 50000, :value => 2, :type_id => energy.id
Upgrade.create :name => "Energy IV", :description => "Increase current energy capacity: X2.", :cost => 500000, :value => 2, :type_id => energy.id
Upgrade.create :name => "Uranium I", :description => "Decrease current uranium cost per energy refuel: -10.", :cost => 5000, :value => 10, :type_id => cost.id
Upgrade.create :name => "Uranium II", :description => "Decrease current uranium cost per energy refuel: -10.", :cost => 50000, :value => 10, :type_id => cost.id
Upgrade.create :name => "Uranium III", :description => "Decrease current uranium cost per energy refuel: -10.", :cost => 500000, :value => 10, :type_id => cost.id
Upgrade.create :name => "Uranium IV", :description => "Decrease current uranium cost per energy refuel: -10.", :cost => 5000000, :value => 10, :type_id => cost.id


component1 = Component.create :name => "iron plate", :description => "Sturdy iron plate.", :research_cost => 500, :build_cost => 50
component2 = Component.create :name => "copper wire", :description => "Roll of copper wire.", :research_cost => 200, :build_cost => 20
component3 = Component.create :name => "tin plate", :description => "sturdy tin plate.", :research_cost => 300, :build_cost => 30
component4 = Component.create :name => "uranium rod", :description => "Highly radioactive rod.", :research_cost  => 10000, :build_cost => 1000
component5 = Component.create :name => "computer", :description => "High tech computer.", :research_cost  => 10000, :build_cost => 1000

ComponentResource.create :resource_id => iron.id, :component_id => component1.id, :amount => 50
ComponentResource.create :resource_id => copper.id, :component_id => component2.id, :amount => 20
ComponentResource.create :resource_id => tin.id, :component_id => component3.id, :amount => 50
ComponentResource.create :resource_id => uranium.id, :component_id => component4.id, :amount => 500
ComponentResource.create :resource_id => iron.id, :component_id => component5.id, :amount => 500
ComponentResource.create :resource_id => copper.id, :component_id => component5.id, :amount => 500

ship1 = Ship.create :name => "shuttle", :research_cost => 2000, :build_cost => 500, :build_time => 60, :carry_capacity => 100
    ShipComponent.create :ship_id => ship1.id, :component_id => component1.id, :amount => 2
    ShipComponent.create :ship_id => ship1.id, :component_id => component2.id, :amount => 5

ship2 = Ship.create :name => "corvette", :research_cost => 4000, :build_cost => 800, :build_time => 180, :carry_capacity => 200
    ShipComponent.create :ship_id => ship2.id, :component_id => component1.id, :amount => 5
    ShipComponent.create :ship_id => ship2.id, :component_id => component2.id, :amount => 10
    ShipComponent.create :ship_id => ship2.id, :component_id => component3.id, :amount => 2

ship3 = Ship.create :name => "frigate", :research_cost => 8000, :build_cost => 1200, :build_time => 300, :carry_capacity => 300
    ShipComponent.create :ship_id => ship3.id, :component_id => component1.id, :amount => 8
    ShipComponent.create :ship_id => ship3.id, :component_id => component2.id, :amount => 10
    ShipComponent.create :ship_id => ship3.id, :component_id => component3.id, :amount => 5
    ShipComponent.create :ship_id => ship3.id, :component_id => component4.id, :amount => 2

ship4 = Ship.create :name => "destroyer", :research_cost => 16000, :build_cost => 2000, :build_time => 600, :carry_capacity => 400
    ShipComponent.create :ship_id => ship4.id, :component_id => component1.id, :amount => 20
    ShipComponent.create :ship_id => ship4.id, :component_id => component2.id, :amount => 12
    ShipComponent.create :ship_id => ship4.id, :component_id => component3.id, :amount => 10
    ShipComponent.create :ship_id => ship4.id, :component_id => component4.id, :amount => 6
    ShipComponent.create :ship_id => ship4.id, :component_id => component5.id, :amount => 1
