require 'rubygems'
require 'yaml'
require 'redcarpet'

class String
  def del!(regex)
    gsub!(regex, '')
  end
end

$dont_render = ['release-notes.md']

markdown_toc_parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC.new(),
  :fenced_code_blocks => true,
  :autolink => true,
  :no_intra_emphasis => true,
  :space_after_headers => false
)

markdown_parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(),
  :fenced_code_blocks => true,
  :autolink => true,
  :no_intra_emphasis => true,
  :space_after_headers => false
)

$html_string = ""

dirs_to_render = ['dev', 'ops', 'theory']

$html_string << markdown_parser.render(File.read('build/index.md'))

Dir['../source/languages/en/riak/**/*.md'].each do |file|
  if !($dont_render.include? file)
    raw_file_contents = File.read(file)
    raw_file_contents.gsub!(/\/images/, '../source/images')
    $html_string << markdown_parser.render(raw_file_contents)
  end
end

final_string = """<html>
  <head>
    <title>The Riak Documentation</title>
  </head>
  <body>
    #{$html_string}
  </body>
</html>"

File.write('build/docs.html', final_string)