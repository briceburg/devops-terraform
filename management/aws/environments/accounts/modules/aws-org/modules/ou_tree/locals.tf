locals {
  level_1 = [
    for v in setproduct(var.level_0, var.level_1) : {
      root   = v[0]
      parent = v[0]
      name   = v[1]
      key    = lower("${v[0]}/${v[1]}")
    }
  ]
  level_2 = [
    for v in setproduct(var.level_0, var.level_1, var.level_2) : {
      root   = v[0]
      parent = lower("${v[0]}/${v[1]}")
      name   = v[2]
      key    = lower("${v[0]}/${v[1]}/${v[2]}")
    }
  ]
}


