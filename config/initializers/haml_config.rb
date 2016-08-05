# @see https://github.com/haml/haml/blob/4.0.7/lib/haml/filters.rb#L207-L227
module Haml
  module Filters
    # Surrounds the filtered text with `<script>` and CDATA tags. Useful for
    # including inline Javascript.
    module Javascript
      include Base

      # @see Base#render_with_options
      def render_with_options(text, options)
        indent = options[:cdata] ? '    ' : '  ' # 4 or 2 spaces
        if options[:format] == :html5
          type = ''
        else
          type = " type=#{options[:attr_wrapper]}text/javascript#{options[:attr_wrapper]}"
        end

        str = "<script#{type}>\n"
        str << "  //<![CDATA[\n" if options[:cdata]
        str << "#{indent}#{my_html_escape(text.rstrip.gsub("\n", "\n#{indent}"))}\n"
        str << "  //]]>\n" if options[:cdata]
        str << "</script>"

        str
      end

      # @see https://github.com/haml/haml/blob/4.0.7/lib/haml/helpers.rb#L520-L546
      # Characters that need to be escaped to HTML entities from user input
      HTML_ESCAPE = { '&'=>'&amp;', '<'=>'&lt;', '>'=>'&gt;', '"'=>'&quot;', "'"=>'&#039;', }
      HTML_ESCAPE_REGEX = /[\"><&]/
      def my_html_escape(text)
        text = text.to_s
        text.gsub(HTML_ESCAPE_REGEX) {|s| HTML_ESCAPE[s]}
      end
    end
  end
end
