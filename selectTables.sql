SELECT TransportationId, FkRouteName RouteName, Name, Surname
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
JOIN Driver ON FkDriverId = DriverId

SELECT 
FROM TransportationsJournal
JOIN Transportation ON FkTransportationId=TransportationId
JOIN Driver ON FkDriverId = DriverId
JOIN Route ON Route.Name=FkRouteName
LEFT JOIN Premium ON PremiumId=FkPremiumId