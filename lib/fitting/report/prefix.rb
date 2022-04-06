require 'fitting/report/actions'

module Fitting
  module Report
    class Prefix
      KEYS = {
        'openapi2' => :openapi2_json_path,
        'openapi3' => :openapi3_yaml_path,
        'drafter' => :drafter_yaml_path,
        'crafter' => :crafter_yaml_path,
        'tomogram' => :tomogram_json_path
      }.freeze

      attr_reader :name, :tests, :actions

      def initialize(schema_paths: nil, type: nil, name: '', skip: false, only: [])
        @name = name
        @cover = false

        @actions = Fitting::Report::Actions.new([])
        return if skip

        schema_paths.each do |path|
          tomogram = Tomograph::Tomogram.new(prefix: name, KEYS[type] => path)

          tomogram.to_a.filter! { |action| only.include?("#{action.method} #{action.path}") } if only.present?

          @actions.push(Fitting::Report::Actions.new(tomogram))
        end
      end

      def mark!
        @cover = true
      end

      def cover?
        @cover
      end
    end
  end
end
