# frozen_string_literal: true

require 'rspec'
require_relative '../lib/main'

RSpec.describe Main do
  let(:companies_file) { 'companies.json' }
  let(:users_file) { 'users.json' }

  subject { described_class.new(companies_file:, users_file:) }

  describe '#run' do
    it 'generates an expected report' do
      expected_report = <<~REPORT
        Company Id: 1
        Company Name: Blue Cat Inc.
        Users Emailed:
        \tBeck, Terra, terra.beck@demo.com
        \t\tPrevious Token Balance: 41
        \t\tNew Token Balance: 41
        \tCarr, Genesis, genesis.carr@demo.com
        \t\tPrevious Token Balance: 71
        \t\tNew Token Balance: 142
        \tFox, Fernando, fernando.fox@fake.com
        \t\tPrevious Token Balance: 48
        \t\tNew Token Balance: 48
        \tLynch, Eileen, eileen.lynch@fake.com
        \t\tPrevious Token Balance: 40
        \t\tNew Token Balance: 111
        \tPierce, Amanda, amanda.pierce@fake.com
        \t\tPrevious Token Balance: 24
        \t\tNew Token Balance: 24
        Users Not Emailed:
        \tGomez, Billy, billy.gomez@notreal.com
        \t\tPrevious Token Balance: 39
        \t\tNew Token Balance: 39
        \tJackson, Brian, brian.jackson@notreal.com
        \t\tPrevious Token Balance: 100
        \t\tNew Token Balance: 100
        Total amount of top ups for Blue Cat Inc.: 142


        Company Id: 2
        Company Name: Yellow Mouse Inc.
        Users Emailed:
        \tBoberson, Bob, bob.boberson@test.com
        \t\tPrevious Token Balance: 23
        \t\tNew Token Balance: 60
        \tBoberson, John, john.boberson@test.com
        \t\tPrevious Token Balance: 15
        \t\tNew Token Balance: 52
        \tNichols, Tanya, tanya.nichols@test.com
        \t\tPrevious Token Balance: 23
        \t\tNew Token Balance: 23
        \tSimpson, Natalie, natalie.simpson@test.com
        \t\tPrevious Token Balance: 89
        \t\tNew Token Balance: 89
        \tSimpson, Edgar, edgar.simpson@notreal.com
        \t\tPrevious Token Balance: 67
        \t\tNew Token Balance: 104
        Users Not Emailed:
        \tGordon, Sara, sara.gordon@test.com
        \t\tPrevious Token Balance: 22
        \t\tNew Token Balance: 59
        \tWeaver, Sebastian, sebastian.weaver@fake.com
        \t\tPrevious Token Balance: 66
        \t\tNew Token Balance: 103
        Total amount of top ups for Yellow Mouse Inc.: 185


        Company Id: 3
        Company Name: Red Horse Inc.
        Users Emailed:
        \tGeorge, Mary, mary.george@test.com
        \t\tPrevious Token Balance: 37
        \t\tNew Token Balance: 92
        \tJimerson, Jim, jim.jimerson@test.com
        \t\tPrevious Token Balance: 10
        \t\tNew Token Balance: 65
        \tNederson, Ned, ned.nederson@test.com
        \t\tPrevious Token Balance: 3
        \t\tNew Token Balance: 58
        \tRobinson, Alexis, alexis.robinson@test.com
        \t\tPrevious Token Balance: 45
        \t\tNew Token Balance: 45
        Users Not Emailed:
        \tCastro, Monica, monica.castro@notreal.com
        \t\tPrevious Token Balance: 69
        \t\tNew Token Balance: 124
        \tDean, Claire, claire.dean@test.com
        \t\tPrevious Token Balance: 98
        \t\tNew Token Balance: 153
        \tSilva, Elsie, elsie.silva@fake.com
        \t\tPrevious Token Balance: 49
        \t\tNew Token Balance: 104
        Total amount of top ups for Red Horse Inc.: 330


        Company Id: 4
        Company Name: Yellow Frog Inc.
        Users Emailed:
        \tKnight, Noah, noah.knight@fake.com
        \t\tPrevious Token Balance: 23
        \t\tNew Token Balance: 56
        \tWells, Bernard, bernard.wells@demo.com
        \t\tPrevious Token Balance: 74
        \t\tNew Token Balance: 74
        \tWhite, Rodney, rodney.white@fake.com
        \t\tPrevious Token Balance: 53
        \t\tNew Token Balance: 53
        Users Not Emailed:
        \tFisher, Kenzi, kenzi.fisher@demo.com
        \t\tPrevious Token Balance: 51
        \t\tNew Token Balance: 51
        \tGardner, Alexander, alexander.gardner@demo.com
        \t\tPrevious Token Balance: 40
        \t\tNew Token Balance: 73
        \tObrien, Ava, ava.obrien@demo.com
        \t\tPrevious Token Balance: 93
        \t\tNew Token Balance: 93
        \tPerkins, Yvonne, yvonne.perkins@notreal.com
        \t\tPrevious Token Balance: 51
        \t\tNew Token Balance: 51
        \tRodriquez, Brent, brent.rodriquez@test.com
        \t\tPrevious Token Balance: 96
        \t\tNew Token Balance: 129
        \tWard, Adrian, adrian.ward@notreal.com
        \t\tPrevious Token Balance: 25
        \t\tNew Token Balance: 58
        \tWoods, Joy, joy.woods@test.com
        \t\tPrevious Token Balance: 1
        \t\tNew Token Balance: 1
        Total amount of top ups for Yellow Frog Inc.: 132


        Company Id: 5
        Company Name: Purple Fish Inc.
        Users Emailed:
        \tBerry, Paul, paul.berry@notreal.com
        \t\tPrevious Token Balance: 19
        \t\tNew Token Balance: 101
        Users Not Emailed:
        \tBarnes, Rodney, rodney.barnes@test.com
        \t\tPrevious Token Balance: 43
        \t\tNew Token Balance: 43
        \tBerry, Nicholas, nicholas.berry@notreal.com
        \t\tPrevious Token Balance: 39
        \t\tNew Token Balance: 121
        \tGraves, Rachel, rachel.graves@fake.com
        \t\tPrevious Token Balance: 26
        \t\tNew Token Balance: 108
        Total amount of top ups for Purple Fish Inc.: 246


        Company Id: 6
        Company Name: Red Deer Inc.
        Users Emailed:
        Users Not Emailed:
        Total amount of top ups for Red Deer Inc.: 0
      REPORT

      expect(subject.run).to match(expected_report)
    end

    context 'when the file has wrong data format' do
      let(:users_file) { 'amusers.json' }

      it 'throws an error' do
        expect { subject.run }.to raise_error /Unexpected format of the file/
      end
    end
  end
end
