create database dbProject
use dbProject

create table tblAdmin(
				AdminId int identity primary key,
				AdminName varchar(30),
				AdminContact nvarchar(30),
				AdminEmail varchar(30) unique,
				AdminPass nvarchar(30))

	
					

				
create table tblFarmer(
					FarmerId int identity(100,1) primary key,
					FarmerName varchar(30),
					FarmerContactNo nvarchar(10),
					FarmerEmail varchar(30) unique,
					FarmerAddress varchar(50) ,
					FarmerCity varchar(30),
					FarmerState varchar(20),
					FarmerPincocde nvarchar(6),
					FarmerAadhar varchar(max),
					FarmerPAN varchar(max),
					FarmerCertificate varchar(max),
					FarmerPassword nvarchar(20),
					FarmerApproved bit,
					ApprovalAdminId int foreign key references tblAdmin(AdminId))

					
					

				
create table tblBidder(
					BidderId int identity(100,1) primary key,
					BidderName varchar(30),
					BidderContactNo nvarchar(10),
					BidderEmail varchar(30) unique,
					BidderAddress varchar(50) ,
					BidderCity varchar(30),
					BidderState varchar(20),
					BidderPincocde nvarchar(6),
					BidderAadhar varchar(max),
					BidderPAN varchar(max),
					BidderTradeLicense varchar(max),
					BidderPassword nvarchar(20),
					BidderApproved bit,
					ApprovalAdminId int foreign key references tblAdmin(AdminId))
					
					

				
					

create table tblFarmLand(	
						FarmerLandId int identity primary key,
						FarmerId int foreign key references tblFarmer(FarmerId),
						FarmerLandArea varchar(10),
						FarmerLandAddress varchar(30),
						FarmerLandPincode nvarchar(6))
						
			
					

create table tblBank (
				AccountNo nvarchar(20) primary key,
				FarmerId int foreign key references tblFarmer(FarmerId),
				BidderId int foreign key references tblBidder(BidderId),
				IFSC_Code nvarchar(15))

		

create table tblSales(
					SalesId int identity primary key,
					FarmerId int foreign key references tblFarmer(FarmerId),
					BidderId int foreign key references tblBidder(BidderId),
					CropName varchar(20) ,
					Quantity int,
					MinSalePrice int,
					TotalPrice int,
					SoldPrice int,
					SaleDate datetime,
					ApprovalAdminId int foreign key references tblAdmin(AdminId))

					
				
			

create table tblCropRequest(
							RequestId int identity primary key,
							FarmerId int foreign key references tblFarmer(FarmerId),
							CropType varchar(20),
							CropName varchar(20),
							FertilizerType varchar(20),
							Quantity numeric,
							SoilPhCertificate varchar(max),
							CropApproved bit,
							ApprovalAdminId int foreign key references tblAdmin(AdminId))
							
						
						
					
							

create table tblBidding (
					BiddingId int identity primary key , 
					RequestId int foreign key references tblCropRequest(RequestId),
					BidderId int foreign key references tblBidder(BidderId),
					InitialPrice int ,
					CurrentBidPrice int ,
					PreviousBidPrice int, 
					BidCloseTime datetime,
					ApprovalAdminId int foreign key references tblAdmin(AdminId))
					
		
					
					

create table tblContactUs(
                    RequestToken int identity primary key ,
					Email varchar(20),
					--Name
					ContactName varchar(20),
					RequestType varchar(15),
					message varchar(20),
					status varchar(15),
					ApprovalAdminId int foreign key references tblAdmin(AdminId))

	
		
				

create table tblInsurance(
					PolicyNo int identity primary key,
					FarmerId int foreign key references tblFarmer(FarmerId),
					CompanyName varchar(30),
					Season varchar(20),
					Year nvarchar(4),
					Crop varchar(20),
					SumInsured int,
					DateOfInsurance datetime,
					Area decimal ,
					ApprovalAdminId int foreign key references tblAdmin(AdminId))

					
				
					

					
create table tblInsuranceClaim(
					CliamId int identity primary key, 
					PolicyNo int foreign key references tblInsurance(PolicyNo),
					CauseOfClaim varchar(50),
					DateOfLoss datetime,
					DateOfClaim datetime,
					AmountClaimed int, 
					ApprovalStatus varchar(20),
					ApprovalAdminId int foreign key references tblAdmin(AdminId))

					
				
					

create proc sp_bidding
as
begin
select b.BiddingId,c.CropType,c.CropName,b.InitialPrice,b.CurrentBidPrice,b.PreviousBidPrice,b.BidCloseTime from 
tblBidding b join tblCropRequest c on b.RequestId=c.RequestId where b.ApprovalAdminId IS NULL
end 

create proc sp_saleshistory(@id int)
as
begin
select s.SaleDate,s.CropName,s.Quantity,s.MinSalePrice,s.SoldPrice from tblSales s join tblBidder b on s.BidderId=b.BidderId where  b.BidderId=@id
end

create proc sp_salehistoryfarmer(@id int)
as
begin
select s.SaleDate,s.CropName,s.Quantity,s.MinSalePrice,s.SoldPrice from tblSales s join tblFarmer F on s.FarmerId=F.FarmerId where f.FarmerId=@id
end

create proc sp_farmermarket
as
begin
select  c.CropType,c.CropName,c.Quantity,b.InitialPrice,b.CurrentBidPrice,b.BidCloseTime from tblCropRequest c join tblBidding b on c.RequestId=b.RequestId where b.ApprovalAdminId is NuLL
end


create proc sp_approveauction
as
begin
select b.BiddingId,b.BidderId,b.InitialPrice,b.CurrentBidPrice,b.BidCloseTime,b.ApprovalAdminId,f.FarmerId,
C.CropName,c.Quantity from tblBidding b join tblCropRequest c on b.RequestId=c.RequestId join tblFarmer f on c.FarmerId=f.FarmerId
end


select * from tblAdmin
select * from tblFarmer
select * from tblBidder
select * from tblCropRequest
select * from tblBank
select * from tblSales
select * from tblBidding
select * from tblInsuranceClaim
select * from tblInsurance
select * from tblSales
select * from tblContactUs

exec sp_bidding

