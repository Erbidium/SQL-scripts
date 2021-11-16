USE [master]
GO

USE [FreightTransportationDB]
GO

ALTER TABLE Driver
ADD CONSTRAINT Fk_Driver_Premium_Id
FOREIGN KEY (FkPremiumId)
REFERENCES Premium(PremiumId)
GO

ALTER TABLE Driver
ADD CONSTRAINT Fk_Driver_Payment_Id
FOREIGN KEY (FkPaymentId)
REFERENCES Payment(PaymentId)
GO




ALTER TABLE Transportation
ADD CONSTRAINT Fk_Transportation_Driver_Id
FOREIGN KEY (FkDriverId)
REFERENCES Driver(DriverId)
GO

ALTER TABLE Transportation
ADD CONSTRAINT Fk_Transportation_Premium_Id
FOREIGN KEY (FkPremiumId)
REFERENCES Premium(PremiumId)
ON DELETE CASCADE
GO




ALTER TABLE Route
ADD CONSTRAINT Fk_Route_Transportation_id
FOREIGN KEY (FkTransportationId)
REFERENCES Transportation(TransportationId)
ON DELETE CASCADE
GO

ALTER TABLE Route
ADD CONSTRAINT Fk_Route_Payment_Id
FOREIGN KEY (FkPaymentId)
REFERENCES Payment(PaymentId)
ON DELETE CASCADE
GO