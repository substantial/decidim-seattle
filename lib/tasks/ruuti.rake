# frozen_string_literal: true

namespace :ruuti do
  desc "Import processes to Decidim from an exported file."
  task :import_processes, [:filename] => [:environment] do |_t, args|
    filename = args[:filename]

    file = begin
      case File.extname(filename)
      when ".csv"
        Roo::Csv.new(filename)
      when ".xls"
        Roo::Excel.new(filename)
      when ".xlsx"
        Roo::Excelx.new(filename)
      else
        raise "Unknown file type: #{file.original_filename}"
      end
    end

    areas = []

    sheet = file.sheet(0)
    rowi = 0
    sheet.each_row_streaming do |row|
      if rowi < 41
        rowi += 1
        next
      end
      if rowi > 2
        area = ""
        name = ""
        description = {}
        value = nil

        if rowi == 41
          row.each_with_index do |cell, ind|
            # puts ind.inspect
            # puts cell.inspect
          end
          # raise ""
        end

        puts "ROW"
        row.each_with_index do |cell, ind|
          if ind == 2
            # Kaupunginosa
            # puts file.formatted_value(row, cell)
            area = cell.value
            if [3, 8, 14, 25, 26, 27, 39, 42, 43].include?(rowi)
              area = ""
            elsif rowi == 4
              area = "Haaga"
            elsif rowi == 7
              area = "Malmi, Pukinmäki"
            elsif rowi == 12
              area = "Pasila"
            elsif rowi == 13
              area = "Kumpula"
            elsif [15, 16].include?(rowi)
              area = "Latokartano"
            elsif [17, 18].include?(rowi)
              area = "Länsi-Herttoniemi"
            elsif rowi == 22
              area = "Lauttasaari"
            elsif rowi == 23
              area = "Laajasalo"
            elsif rowi == 23
              area = "Laajasalo"
            elsif rowi == 31
              area = "Kannelmäki, Malminkartano"
            elsif [34, 35, 37, 38].include?(rowi)
              area = "Maunula, Pirkkola"
            elsif rowi == 36
              area = "Koskela, Käpylä, Kumpula, Arabia"
            elsif rowi == 36
              area = "Koskela, Käpylä, Kumpula, Arabia"
            elsif rowi == 41
              area = "Suutarila, Jakomäki"
            elsif rowi == 44
              area = "Vartiokylä, Myllypuro"
            end
          elsif ind == 6
            name = cell.value if name.nil? || name.blank?
          elsif ind == 7 # What?
            description[:what] = cell.value.to_s if description[:what].nil?
          elsif ind == 8 # Why?
            description[:why] = cell.value.to_s if description[:why].nil?
          elsif ind == 9 # Who it would benefit?
            description[:who] = cell.value.to_s if description[:who].nil?
          elsif ind == 10 # Sustainable development?
            description[:sustainable] = cell.value.to_s if description[:sustainable].nil?
          elsif ind == 12 # How young people are involved?
            description[:youth] = cell.value.to_s if description[:youth].nil?
          elsif ind == 14 # Value
            if rowi == 44
              value = "10000"
            elsif value.nil? || value.blank?
              value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "")
            end
          end

          # Custom rows
          if rowi == 3
            if ind == 3
              name = cell.value
            elsif ind == 4
              description[:what] = cell.value.to_s
            elsif ind == 5
              description[:why] = cell.value.to_s
            elsif ind == 6
              description[:who] = cell.value.to_s
            elsif ind == 7
              description[:sustainable] = cell.value.to_s
            elsif ind == 9
              description[:youth] = cell.value.to_s
            elsif ind == 11
              value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "")
            end
          elsif rowi == 12
            if ind == 4
              name = cell.value
            elsif ind == 5
              description[:what] = cell.value.to_s
            elsif ind == 6
              description[:why] = cell.value.to_s
            elsif ind == 7
              description[:who] = cell.value.to_s
            elsif ind == 8
              description[:sustainable] = cell.value.to_s
            elsif ind == 10
              description[:youth] = cell.value.to_s
            elsif ind == 12
              value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "")
            end
          elsif rowi == 22
            value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "") if ind == 13
          elsif rowi == 24
            value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "") if ind == 13
          elsif [34, 35, 37, 38, 39].include?(rowi)
            if ind == 5
              name = cell.value
            elsif ind == 6
              description[:what] = cell.value.to_s
            elsif ind == 7
              description[:why] = cell.value.to_s
            elsif ind == 8
              description[:who] = cell.value.to_s
            elsif ind == 9
              description[:sustainable] = cell.value.to_s
            elsif ind == 10
              description[:youth] = cell.value.to_s
            elsif ind == 12
              value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "")
            end
          elsif rowi == 37
            value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "") if ind == 12
          elsif rowi == 38
            value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "") if ind == 12
          elsif rowi == 39
            value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "") if ind == 12
          elsif rowi == 41
            if ind == 5
              name = cell.value
            elsif ind == 6
              description[:what] = cell.value.to_s
            elsif ind == 7
              description[:why] = cell.value.to_s
            elsif ind == 8
              description[:who] = cell.value.to_s
            elsif ind == 9
              description[:sustainable] = cell.value.to_s
            elsif ind == 10
              description[:youth] = cell.value.to_s
            elsif ind == 13
              value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "")
            end
          elsif rowi == 43
            value = cell.value.to_s.gsub(/([.,][0-9]+)|[^0-9]/, "") if ind == 13
          end
        end

        puts rowi.to_s
        puts "Alue: " + area.to_s
        puts "Nimi: " + name.to_s
        puts "Budjetti: " + value.to_s
        puts ""
        description.each do |kv|
          subject = kv[0]
          part = kv[1]

          if subject == :what
            # puts "<h2>Mitä?</h2>"
            puts "Mitä?"
          elsif subject == :why
            # puts "<h2>Miksi?</h2>"
            puts ""
            puts "Miksi?"
          elsif subject == :who
            # puts "<h2>Keitä tämä hyödyttäisi?</h2>"
            puts ""
            puts "Keitä tämä hyödyttäisi?"
          elsif subject == :sustainable
            # puts "<h2>Kestävää kehitystä?</h2>"
            puts ""
            puts "Kestävää kehitystä?"
          elsif subject == :youth
            # puts "<h2>Miten nuoret ovat toteutuksessa mukana?</h2>"
            puts ""
            puts "Miten nuoret ovat toteutuksessa mukana?"
          end
          # puts "<p>" + part.to_s.gsub(/\n/, '<br>') + "</p>"
          puts part.to_s
        end
        puts "==="

        areas << area
      end

      rowi += 1

      break if rowi >= 45
    end

    puts areas.uniq.inspect
  end
end
