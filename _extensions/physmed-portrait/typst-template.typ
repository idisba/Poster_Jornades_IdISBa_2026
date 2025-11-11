#let poster(
  // The poster's title.
  title: "Paper Title",

  // Optional subtitle.
  subtitle: "",

  // A string of author names.
  authors: "Author Names (separated by commas)",

  // Department name.
  departments: "Department Name",

  // Poster banner.
  banner: "Banner/logos Path",

  // Footer text.
  footer_text: "Footer Text",

  // Any URL, like a link to the conference website.
  footer_url: "Footer URL",

  // Email IDs of the authors.
  footer_email_ids: "Email IDs (separated by commas)",

  // Color of the footer (hex, e.g. "#004488").
  footer_color: "Hex Color Code",

  // Subtitle font size (optional)
  subtitle_font_size: "52",

  // Subtitle color (hex, e.g. "#666666")
  subtitle_color: "#666666",
  
 // Language for localization
   lang: "en",

  // DEFAULTS
  // ========
  paper: "a0",
  flipped: true,
  body_font_size: "33",
  keywords: (),
  num_columns: "3",
  left_title_column_size: "0",
  right_title_column_size: "0",
  title_column_size: "20",
  title_row_size: "4.1",
  title_font_size: "48",
  authors_font_size: "36",
  department_font_size: "36",
  footer_url_font_size: "30",
  footer_text_font_size: "40",
  margin_top: "0",
  margin_left: "1",
  margin_right: "1",
  margin_bottom: "2",
  space_after_header: "0",
  body
) = {

  // Set the body font.
  body_font_size = int(body_font_size) * 1pt
  set text(font: "Noto Sans", size: body_font_size)
  title_font_size = int(title_font_size) * 1pt
  subtitle_font_size = int(subtitle_font_size) * 1pt
  authors_font_size = int(authors_font_size) * 1pt
  num_columns = int(num_columns)
  left_title_column_size = float(left_title_column_size) * 1in
  right_title_column_size = float(right_title_column_size) * 1in
  title_column_size = float(title_column_size) * 1in
  title_row_size = float(title_row_size) * 1in
  footer_url_font_size = int(footer_url_font_size) * 1pt
  footer_text_font_size = int(footer_text_font_size) * 1pt
  department_font_size = int(department_font_size) * 1pt
  margin_top = float(margin_top) * 1in
  margin_left = float(margin_left) * 1in
  margin_right = float(margin_right) * 1in
  margin_bottom = float(margin_bottom) * 1in
  space_after_header = float(space_after_header) * 1pt

  let to-string(content) = {
    if content.has("text") {
      content.text
    } else if content.has("children") {
      content.children.map(to-string).join("")
    } else if content.has("body") {
      to-string(content.body)
    } else if content == [ ] {
      " "
    }
  }

  flipped = flipped == "true"
  set text(lang: lang) // 
  set page(
    paper: paper,
    flipped: flipped,
    margin: (top: margin_top, left: margin_left, right: margin_right, bottom: margin_bottom),
    background: align(center + top, image(banner, width: 100%)),
    footer: [
      #set align(center)
      #set text(footer_url_font_size, font: "Courier")
      #block(
        fill: rgb(footer_color),
        width: 100%,
        inset: 20pt,
        radius: 10pt,
        [
          #link(to-string(text(footer_url)))
          #h(1fr)
          #text(size: footer_text_font_size, smallcaps(footer_text))
          #h(1fr)
          #link("mailto:"+to-string(text(footer_email_ids)))[#text(footer_email_ids)]
        ]
      )
    ]
  )

  // Configure headings, equations, etc.
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.7em)
  set enum(indent: 15pt, body-indent: 10pt)
  set list(indent: 15pt, body-indent: 10pt)

  set heading(numbering: "I.A.1.")
  show heading: it => locate(loc => {
    let levels = counter(heading).at(loc)
    let deepest = if levels != () { levels.last() } else { 1 }

    set text(24pt, weight: 400)
    if it.level == 1 [
      #set align(center)
      #set text({ 53pt })
      #show: smallcaps
      #v(52pt, weak: true)
      #if it.numbering != none { numbering("I.", deepest); h(34pt, weak: true) }
      #it.body
      #v(40pt, weak: true)
      #line(length: 100%)
    ] else if it.level == 2 [
      #set text(style: "italic")
      #set text({ 45pt })
      #v(40pt, weak: true)
      #if it.numbering != none { numbering("i.", deepest); h(35pt, weak: true) }
      #it.body
      #v(40pt, weak: true)
    ] else [
      #if it.level == 3 { numbering("1)", deepest); [ ] }
      _#(it.body):_
    ]
  })

// ===== Header centered & ultra-compact =====
align(center + top, [
  #box(width: title_column_size)[
    #set align(center)

    // Títol principal
    #par(leading: 0.4em, text(title_font_size, black, title, weight: 700))
    #v(-20pt)

    // Subtítol (opcional)
    #if subtitle != "" [
      #text(subtitle_font_size, rgb(subtitle_color), subtitle, style: "italic")
      #v(-20pt)
    ]

    // Autors
    #text(authors_font_size, black, authors)
    #v(-20pt)

    // Departaments
    #text(department_font_size, black, departments)
  ]
])
v(space_after_header)

  // Columns of content
  show: columns.with(num_columns, gutter: 64pt)
  set par(justify: true, first-line-indent: 0em,leading: 0.82em)
  show par: set block(spacing: 1.6em)

  if keywords != () [
      #set text(24pt, weight: 400)
      #show "Keywords": smallcaps
      *Keywords* --- #keywords.join(", ")
  ]

  body
}
