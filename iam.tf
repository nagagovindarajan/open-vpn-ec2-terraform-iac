resource "aws_iam_role" "openvpn_ec2_role" {
  name               = "openvpn-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "openvpn_ec2_profile" {
  name = "openvpn_ec2_profile"
  role = aws_iam_role.openvpn_ec2_role.name
}

resource "aws_iam_role_policy" "admin-policy" {
  name = "openvpn-admin-role-policy"
  role = aws_iam_role.openvpn_ec2_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}
