#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    def name
      return text_nodes[2] if position.include? 'Displaced'

      raw = person_node.xpath('text()[1]').text.tidy
      return raw unless raw.empty?

      person_node.text.tidy
    end

    def position
      return text_nodes.take(2).join(' ') if noko.text.include? 'Displaced'

      minister_node.text.tidy
    end

    private

    def minister_node
      noko.css('p').find { |node| node.text.include? 'Minister' }
    end

    def person_node
      minister_node.xpath('following-sibling::*').find { |node| !node.text.tidy.empty? }
    end

    def text_nodes
      noko.css('p').map(&:text).map(&:tidy).reject(&:empty?)
    end
  end

  class Members
    def member_container
      noko.css('.persons-list li')
    end
  end
end

file1 = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file1).csv

file2 = Pathname.new 'html/official2.html'
puts EveryPoliticianScraper::FileData.new(file2).csv.lines.drop(1).join
