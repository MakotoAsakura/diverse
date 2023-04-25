# frozen_string_literal: true

module MarkdownRenderer
  def self.markdown
    @@markdown ||= # rubocop:disable Style/ClassVars
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML.new(
          hard_wrap: true,
          with_toc_data: true
        ),
        autolink: true,
        fenced_code_blocks: true,
        no_intra_emphasis: true,
        space_after_headers: true,
        tables: true
      )
  end

  def self.render(text)
    markdown.render(text)
  end
end
