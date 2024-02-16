resource -

resource name must be unique for every resource 

terraform destroy -
---------------------------------------------------------------
"terraform" destroy 
or 
"terraform destroy -target aws_instance.myec2" ( syntax - terraform destroy -target "resource type.local resource name" ) 

even if you comment the code block or remove the code block from main file like commented ec2 creation block and then do terraform apply , it will destroy the ec2 instance as its commented out 

----------------------------------------------------------------------

state file -

terraform stores the state of infrastrature that is being created by TF file 
this state allows terraform to map real world resources the your exiting resourses 

"Once you create infrastrature from the terraform it will store the created infa information to the state file 
and once you destroy infa it will remove those information from state file , so once again you do plan 
it will read the sate file and will create infa if it is not present in state file , if its present in
state file that means infa is alreday created so it will not create again the same "


----------------------------------------------------------------------------------

desired state -

whatever the infra code you write in TF file that is know as desired state 

current state -

like you have now manually modifiled the ec2 instance to t3.large and in your TF file it is t2.micro 
that means t3.large will be your current state and t2.micro will be your desired state 



-----------------------------------------------------------------------------------------------

output-

this block will provide some specific value to user after resource creation 
like if ec2 created , you can add in output block to give public IP and Public DNS to user after ec2 created 

--------------------------------------------------------------------------------------------------

Variables -

we can assign default variables in variables.tf file , that will be default value of variable if no explicit value is given 
even if in variables.tf file you will not give any defalut value for variable , in runtime it will ask you 

from command line also you can give variable value , preority will be high from variables.tf file .

terraform plan -var="variablename=t2small"     ---> like this 

but giving value all the time in command line is not a best practice , so we can define values of variables in 
terraform.tfvars file 

variables.tf ---- just define the variable name 
terraform.tfvars ------ give the varibale value in this file 


---------------------------------------------------------------------------------------------------------

data type of variable -

you can define the varibale type like  number  , string ...this will take only spacific tyoe of formate
best practice always define the variable type  

---------------------------------------------------------------------------------------------------------

Conditional Expression -

" condition ? true_value : false_value "

----------------------------------------------------------------------------------------------------------

local values -

we can define a local block in our tf file 
that can be refered in entire terraform code 

we can refer as local."name of local"

like -

ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpn_ip]
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpn_ip]
  }

In above code 443 value is repeating 
we cam define a local block as below -

ingress {
    description      = "TLS from VPC"
    from_port        = local.app_port
    to_port          = local.app_port
    protocol         = "tcp"
    cidr_blocks      = [var.vpn_ip]
  }

    ingress {
    description      = "TLS from VPC"
    from_port        = local.app_port
    to_port          = local.app_port
    protocol         = "tcp"
    cidr_blocks      = [var.vpn_ip]
  }

  locals {
      app_port = 443
  }

----------------------------------------------------------------------------------------------------------

Function -

function ( aargument1,argument2 )

Like - max ( 12,9,5)
12

not support user define , only builtin support 

we can test function in "terraform console"

---------------------------------------------------------------------------------------------------------

Data source -

with the help of data souce we can fetch information from provider like aws ( like aws ami id etc )
and can refer in terraform code 

-------------------------------------------------------------------------------------------------------------

terraform validate -

this command will validate your tf file if there is any mistake in file 

-----------------------------------------------------------------------------------------------------------------

Load order and symentics -

In production it is not good practice to write all the codes in one terraform file we can maintain multiple terraform file 
like provider.tf and put provider info , ec2.tf and put ec2 related configuration , iam.tf put iam related configuration 
so that in future it will be easy to make any modification or we can add resource easly 


-----------------------------------------------------------------------------------------------------------------------

dynamic Block -

like we are creating a security group and we need to add many inbound and outbound rules , it is deficult to write configuation for all the rules
here dynamic blocks comes , we can one dynamic bolock for all the inbound rules 
its like , it will create a loop 

-------------------------------------------------------------------------------------------------------------------------

Tainting resources -

terraform taint = recreating the resorce that were already created through terraform 

Suppose you created resource through terraform and some one manually change the configuration of server and your application went down
so you can revert the terraform resource to that particular working version , that is called tainting .

we can do -replace , this will destroy the current instance and launch a new instance.

terraform apply -replace="aws_instance.myec2"

Note = terraforn taint was in older version 
-replace can do same task in newer versions 

---------------------------------------------------------------------------------------------------------------------------------------------

splat expressions -

[*] - this is splat expressions 

you can use it like in output block to display a attributes for all resources 
like - you are creating 5 ec2 and then you can use it in output block to get public IP of all ec2 

--------------------------------------------------------------------------------------------------------------------------------

Terraform Graph -

The terraform graph will applow us to generate a visual presentation of either a configuation or execution plan 
its in a dot formate 

for this you need to install a package in the windows or linux to get the visiual representation ( graphviz package ) 

how to do that -
first do "terraform graph > graph.dot" this will create a graph.dot file bassed on .tf file 
1 - install package in linux 
2 - convert the .dot file to .svg file with below command 
cat graph.dot | dot -Tsvg > graph.svg
3 . you can open graph.svg file with google chrome and it will show visual representation 

-----------------------------------------------------------------------------------------------------------------------------------------

Saving terraform plan to file -

we can save our terraform to a file so that what we have planned that only we can apply .
sometime in big environment many users commit the changes , so better to save plan to a file and then appply 

terraform plan -out="file_path"
terraform apply "file_path"

-------------------------------------------------------------------------------------------------------------------------------------

"terraform output" command-

with terraform output you can get the value of output variable from state file

-------------------------------------------------------------------------------------------------------------------------------------

terraform setting -

In terraform file we have one terraform block where we can mention  terraform setting like terraform version , provider version etc 

example -
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

----------------------------------------------------------------------------------------------------------------------------------------

for each in terraform 
----------------------------------

with the list like name = [ user1 , user2 , user3 ]
now if we do count.index , it will take 0th position user1 and so on 
like now if we add one more element in list [ user0 , user1 , user2 , user3 ] and do apply
as element position got change , it will affect the complete resource creaton 

to resolve this for each comes into the picture -

for_each = toset([ user1 , user2 , user3 ])         ##( toset function will remove duplicate entry ) 
name = each.key

now each item name will be treated as key to it will not depend in the element order .

--------------------------------------------------------------------------------------------------------------------------------------

Terraform Provisioners -

Provisioners are used to execute te script on a local or a remote machine as part of resource creation or distruction 

Like - On creation of web server execute a script that installs a NGINX web server 

---------------------------------------------------------------------------------------------------------------------------------------

Types of provisioners -

1 - Local Provisioners ( local-exec) - This provisioners will help to execute a command in loxal machine from where u r running the terraform 

like - provisioner "local-exec" {
                command = "echo ${aws_instance.web.private_ip} >> privateip.txt
		}

( this will run the command in local machine and store the private ip of created resource in the privateip.txt file )

2 - remote exec provisioners -

remote-exec help to run commands in remote machine 
like we created a ec2 instance through terraform and we can run some commands to install web server on that machine 
with help of remote-exec provisioners 

--------------------------------------------------------------------------------------------------------------------------------------------------

Terraform Workspace -

terraform workspace -h = will show the terraform workspace commands
terraform workspace show = will show the current workspace 
terraform workspace new "name of workspace" = will create new workspace 

**************************************************************************************************************************

Terraform default bahaviour and use of meta argument -
----------------------------------------------------------

suppose you have deployed an ec2 instance with tag value name=firstec2 and now someone came and chnage the name manually from aws console 
now once you will do terraform apply , it will again chnage the tag value to name=firstec2 .
suppose you dont want this chnage and wants to ignore the manual chnage , meta argument will help here 

write a lifecycle block insde the resource block to ignoire the change 
lifecycle {
     ignore_chnages = [tags]
     }
now once you will run terraform apply , any chnages related to tags will be ignored 
there are a lot of meta argument is allowed in terraform , lifecycle is one of them 
depends_on
count
for_each
lifecycle 
provider 



     
