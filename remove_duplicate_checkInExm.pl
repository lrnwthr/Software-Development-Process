#!/usr/bin/perl
#**********************************************************************************#
# xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxX#
#                                                                                  #
#                                                                                  #
# PROGRAM: remove_duplicateCount.pl                                                #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# DESCRIPTION :  This program do following things                                  #
#                1)Remove duplicate email and phone number                         #
#	             2)Sort phone number and email                                 #
#                3)Generate new sorted and unique phone and                        #
#                   email file      	                                           #	  
#                                                                                  #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# INPUT PARMS: None                                                                #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# INPUT FILES: email.txt,phone.txt,lastCountFile.txt                                #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# OUTPUT FILE:  sortedEmail.txt ,sortedPhone.txt ,newNumberInList.txt              #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# EXITS:       0 - success                                                         #
#                                                                                  #
#             -1 - failure                                                         #
#                                                                                  #
#                                                                                  #
#                                                                                  #
#**********************************************************************************#
#                                                                                  #
#                                                                                  #
#                                                                                  #
#                     Modification Log                                             #
#                                                                                  #
#                                                                                  #
#                                                                                  #
# Date        CSR/CO   Author            Description                               #
#                                                                                  #
# ----------  ------   --------------    -----------------                         #
#                                                                                  #
# 08/27/2013           Rakesh malviya      Initial implementation.                 #
#                                                                                  #
# 02/26/2014   CH#1    hitesh sharma      added trim function                       #
#                                                                                  #
#**********************************************************************************#

use File::Copy qw(move); 
use List::MoreUtils qw{ any };
my $index=0;
my $total =0;
my $WrtRecCount =0;
my $duplicateCount = 0;
my $email_file = "email.txt";

#define status 0

# Remove spaces from front and back side
#Start CH#1
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };
#End CH#1
# Find duplicate value Avoiding duplicateCount value by comparing current value with previous value
sub findString
{

my $result = 0; 

 my ($currentPattern, @prevArray) = @_;

 foreach my $prevArrayElement (@prevArray)
 {

    $currentPattern = trim($currentPattern);
    $prevArrayElement = trim($prevArrayElement);
    if($currentPattern eq $prevArrayElement)
    {

      $result = 1;
    }

 }

  return $result;
}

####################################################################################
#
#
#
#                                START OF PROGRAM
#
#
#####################################################################################
print("                            Email Report                                  \n");


#-----------------------------------------------
# Logic to Sorting email and remove duplicateCount value
#----------------------------------------------

#File for current email list
my $emailFile = "email.txt";

#File for previous run email
my $sortFile = "sortEmail.txt";
#Wrong Conding Standard
my $prevemail_file = $sortFile; 
my @prevArr;

# Checking email.txt file exist or not if does not then control does not go inside if condition 
# Inside this if condition only we remove duplicateCount email and sort the email 
if(-e $emailFile)
{
     open FILE, $emailFile or die "Can't open $emailFile\n";
     my @lines = <FILE>;
     close FILE;
     
     
     if(-e $prevemail_file)
     {
        open FILE, $prevemail_file or die "Can't open $prevemail_file\n";
        @prevArr=<FILE>;
        close FILE;
     }
     my @sortedArray = sort @lines;
     my $prevLine = "rakk";
     
     open(my $email_fileHan, '>>', $sortFile) or die "Could not open file $sortFile $!";
# remove duplicateCount value by coparing current and previous run email
foreach my $nextLine (@sortedArray)
{ 


    my $size = scalar(@prevArr);
    my $result = findString($nextLine , @prevArr);
     
    $total = $total+1;
    $nextLine = trim($nextLine);
    if($nextLine ne  $prevLine && $result != 1)
    {
    
      $WrtRecCount = $WrtRecCount+1;
      print $email_fileHan "$nextLine\n";
    }
    $prevLine = trim($nextLine);

}

close $email_fileHan;
$duplicateCount = $total - $WrtRecCount;
print("-------------------------------------------------------------------------\n");
print("Total  Email | Total Unique Email | Total Duplicate Email\n");
print("$total            | $WrtRecCount                  | $duplicateCount\n");
print("-------------------------------------------------------------------------\n");
}
else
{

 print("Error ,Please create $emailFile  file , it does not exist\n\n");
}

#-----------------------------------------------
# Logic to Sorting Phone Number and remove duplicateCount value
#----------------------------------------------

print("\n\n                            phone Report                                  \n");
$index=0;
$total =0;
$WrtRecCount =0;
$duplicateCount = 0;

#phone.txt contain current phone number
my $emailFile = "phone.txt";
#sortPhone.txt contain previous run phone email
my $sortFile = "sortPhone.txt";
my $prevemail_file = $sortFile;
# New number will come in below file
my $finalFilePhone = "NameNumber.txt";
# value in this file will be use to looping purpose
my $lstContFile = "lastCountFile.txt";
my @prevArr;
my $appendNum;

# IF phone.txt exist then only then go inside loop

if(-e $emailFile)
{
    open FILE, $emailFile or die "Can't open $emailFile\n";
    my @lines = <FILE>;
    close FILE;

     # opening sortphone.txt file

    if(-e $prevemail_file)
    {
       open FILE, $prevemail_file or die "Can't open $prevemail_file\n";
       @prevArr=<FILE>;
       close FILE;
    }


    # sorting array 
    my @sortedArray = sort @lines;
    my $prevLine = "rakk";

       #open lastcount file to get last count
       open FILE, $lstContFile or die "Can't open $prevemail_file\n";
       @counter=<FILE>;
       close FILE;

    # opening file in append mode
    open(my $email_fileHan, '>>', $sortFile) or die "Couldiiiiii not open file $sortFile $!";

    open FinalPhoneHan, "+>$finalFilePhone" or die "Couldn't open file $finalFilePhone, $!";

    #opening file in overwrite mode
    open lastContHan, "+>$lstContFile" or die "Couldn't open file $lstContFile, $!";
#    print("last count = $counter[0]\n");
foreach my $nextLine (@sortedArray)
{

  my $result =0;
  my $size = scalar(@prevArr);
  if($size >0)
  {
     $result = findString($nextLine , @prevArr);
  }

 $total = $total+1;
 $nextLine = trim($nextLine);

 # Comparing last run phone number and current list phone number and removing duplicateCount
 if($nextLine ne  $prevLine && $result != 1)
 {

   $WrtRecCount = $WrtRecCount+1;
   $appendNum = $WrtRecCount + $counter[0]; 
   print $email_fileHan "$nextLine\n";

   # Genrating Unique name as well for each phone number
   print FinalPhoneHan "Z$appendNum,$nextLine\n";
 }
# else
# {
#   print("duplicateCount value = $nextLine\n");
# }
$prevLine = trim($nextLine);

}

if($WrtRecCount > 0)
{
   print lastContHan $appendNum;
}
else 
{
   print lastContHan $counter[0];
}
close $email_fileHan;
close FinalPhoneHan;
close lastCountFile;
$duplicateCount = $total - $WrtRecCount;
print("-------------------------------------------------------------------------\n");
print("Total Phone Number | Total Unique Phone Number | Total Duplicate Phone Number\n");
print("$total                  | $WrtRecCount                        | $duplicateCount\n");
print("-------------------------------------------------------------------------\n");
}
else
{

 print("Error , Please create $emailFile  file , it does not exist\n\n");
}


