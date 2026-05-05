module ApplicationHelper
  ICON_PATHS = {
    "menu" => [
      "M4 6h16M4 12h16M4 18h16"
    ],
    "calendar" => [
      "M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
    ],
    "chevron-down" => [
      "M19 9l-7 7-7-7"
    ],
    "home" => [
      "M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
    ],
    "plus-circle" => [
      "M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
    ],
    "list" => [
      "M4 6h16M4 10h16M4 14h16M4 18h16"
    ],
    "check-circle" => [
      "M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
    ],
    "users" => [
      "M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"
    ],
    "chart-bar" => [
      "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
    ],
    "cog" => [
      "M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z",
      "M15 12a3 3 0 11-6 0 3 3 0 016 0z"
    ]
  }.freeze

  def app_icon(name, css_class: "", stroke_width: 2, extra_classes: nil)
    paths = ICON_PATHS.fetch(name) do
      raise ArgumentError, "Unknown icon: #{name}"
    end

    classes = [ css_class, extra_classes ].compact.join(" ").strip
    svg_paths = safe_join(paths.map { |path_data| icon_path_tag(path_data) })

    content_tag(
      :svg,
      svg_paths,
      xmlns: "http://www.w3.org/2000/svg",
      class: classes.presence,
      fill: "none",
      viewBox: "0 0 24 24",
      stroke: "currentColor",
      "stroke-width": stroke_width
    )
  end

  private

  def icon_path_tag(path_data)
    tag.path(
      "stroke-linecap": "round",
      "stroke-linejoin": "round",
      d: path_data
    )
  end
end
