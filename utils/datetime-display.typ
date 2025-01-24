// 显示中文日期
#let datetime-display(date, format: "[year] 年 [month] 月 [day] 日") = {
  date.display(format)
}

// 显示英文日期
#let datetime-en-display(date, format: "[month repr:short] [day], [year]") = {
  date.display(format)
}