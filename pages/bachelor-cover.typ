#import "../utils/datetime-display.typ": datetime-display
#import "../utils/style.typ": 字号, 字体
#import "../utils/custom-cuti.typ": fakebold

// 本科生封面
#let bachelor-cover(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  stoke-width: 0.5pt,
  min-title-lines: 2,
  info-inset: (x: 0pt, bottom: 1pt),
  info-key-width: 72pt,
  info-key-font: "宋体",
  info-value-font: "宋体",
  column-gutter: -3pt,
  row-gutter: 1.28em,
  anonymous-info-keys: ("grade", "student-id", "author", "supervisor", "supervisor-ii"),
  bold-info-keys: (),
  bold-level: "bold",
  datetime-display: datetime-display,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title: ("基于 Typst 的", "吉林大学学位论文"),
    title-en: "My Title in English",
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    department: "某学院",
    major: "某专业",
    supervisor: "李四",
    submit-date: datetime.today(),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }
  // 2.2 根据 min-title-lines 填充标题
  info.title = info.title + range(min-title-lines - info.title.len()).map((it) => "　")
  info.title-en = info.title-en + range(min-title-lines - info.title-en.len()).map((it) => "　")
  // 2.3 处理提交日期
  if type(info.submit-date) == datetime {
    info.submit-date = datetime-display(info.submit-date, format: "[year] 年 [month] 月")
  }

  // 3.  内置辅助函数
  let info-key(body) = {
    set text(font: fonts.宋体, size: 字号.三号)
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      fakebold(body)
    )
  }

  let info-value(key, body) = {
    set align(center)
    rect(
      width: 100%,
      inset: info-inset,
      stroke: (bottom: stoke-width + black),
      text(
        font: fonts.at(info-value-font, default: "宋体"),
        size: 字号.三号,
        weight: if (key in bold-info-keys) { bold-level } else { "regular" },
        bottom-edge: "descender",
        body,
      ),
    )
  }

  let info-long-value(key, body) = {
    grid.cell(colspan: 3,
      info-value(
        key,
        if anonymous and (key in anonymous-info-keys) {
          "██████████"
        } else {
          body
        }
      )
    )
  }

  let info-short-value(key, body) = {
    info-value(
      key,
      if anonymous and (key in anonymous-info-keys) {
        "█████"
      } else {
        body
      }
    )
  }
  

  // 4.  正式渲染
  
  pagebreak(weak: true, to: if twoside { "odd" })

  // 居中对齐
  set align(center)

  // 匿名化处理去掉封面标识
  if anonymous {
    v(52pt)
  } else {
    // 封面图标
    // 调整一下左边的间距
    image("../assets/cover.png", width: 13.23cm)
    v(2pt)
  }

  // 将中文之间的空格间隙从 0.25 em 调整到 0.5 em
  text(size: 字号.小初, font: fonts.宋体, weight: "bold")[本科生毕业论文（设计）]
  
  if anonymous {
    v(155pt)
  } else {
    v(3em * 1.5)
  }

  block(width: 380pt, grid(
    columns: (info-key-width, 1fr, info-key-width, 1fr),
    column-gutter: column-gutter,
    row-gutter: row-gutter,
    info-key("中文题目"),
    ..info.title.map((s) => info-long-value("title", s)).intersperse(info-key("　")),
    info-key("英文题目"),
    ..info.title-en.map((s) => info-long-value("title-en", s)).intersperse(info-key("　")),
  ))

  v(4em * 1.5)

  block(width: 380pt, grid(
    columns: (info-key-width, 1fr, info-key-width, 1fr),
    column-gutter: column-gutter,
    row-gutter: row-gutter,
    info-key("学生姓名"),
    info-long-value("author", info.author),
    info-key("学　　号"),
    info-long-value("student-id", info.student-id),
    info-key("学　　院"),
    info-long-value("department", info.department),
    info-key("专　　业"),
    info-long-value("major", info.major),   
    
    info-key("指导教师"),
    info-long-value("supervisor", info.supervisor.at(0)),
    ..(if info.supervisor-ii != () {(
      info-key("第二导师"),
      info-long-value("supervisor-ii", info.supervisor-ii.at(0)),
    )} else {()}),
  ))

  v(2em * 1.5)

  text(info.submit-date, font: fonts.宋体, size: 字号.三号, weight: "bold")
}
