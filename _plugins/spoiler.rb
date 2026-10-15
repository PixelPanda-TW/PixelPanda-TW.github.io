#!/usr/bin/env ruby
#
# Convert Discord-style spoilers `||text||` in Markdown into clickable spoiler spans

SPOILER_RE = /\|\|(?=\S)(.+?)(?<=\S)\|\|/

Jekyll::Hooks.register [:pages, :documents], :pre_render do |doc|
  next unless doc.extname =~ /\.(md|markdown)$/i

  # Skip fenced code blocks and inline code
  parts = doc.content.split(/(```.*?```|`[^`\n]*`)/m)
  doc.content = parts.each_with_index.map do |s, i|
    next s if i.odd?

    s.gsub(SPOILER_RE) do
      %(<span class="spoiler" role="button" tabindex="0" ) +
        %(onclick="this.classList.add('revealed')">#{$1}</span>)
    end
  end.join
end
