resource "local_file" "bar" {
  content  = templatefile("${path.module}/templates/temp.txt.tftpl", {temp: var.input})
  filename = "${var.dir}/output.txt"
}
