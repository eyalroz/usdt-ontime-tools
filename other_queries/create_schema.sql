-- Table for the USDT On-Time Performance data
-- downloadable from here: http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time
-- as monthly CSV files.
--
-- The designation of some fields as nullable and others as non-null is based on examining all data
-- for years 1987-2009; when no missing values were found the column was determined to be non-null

CREATE TABLE ontime (
	Year_                SMALLINT      NOT NULL,
	Quarter              TINYINT       NOT NULL,
	Month_               TINYINT       NOT NULL,
	DayofMonth           TINYINT       NOT NULL,
	DayOfWeek            TINYINT       NOT NULL,
	FlightDate           DATE          NOT NULL,
	UniqueCarrier        CHAR(2)       NOT NULL,
	AirlineID            INT           NOT NULL,     -- In the data for 2000-2008 this only goes as high
	                                                 -- as 20500 or so, but let's be a little future-proof
	Carrier              CHAR(2)       NOT NULL,
	TailNum              VARCHAR(6)    DEFAULT NULL, -- should be an alphanumeric sequence or "UNKNOW",
	                                                 -- but in fact we sometimes get some junk, 
	                                                 -- including non-ASCII; and there are quite a few
	                                                 -- values here that are shorter than 6 chars
	FlightNum            VARCHAR(4)    NOT NULL,
	OriginAirportID      INT           NOT NULL,
	OriginAirportSeqID   INT           NOT NULL,
	OriginCityMarketID   INT           NOT NULL,
	Origin               CHAR(3)       NOT NULL,
	OriginCityName       VARCHAR(40)   NOT NULL,
	OriginState          CHAR(2)       DEFAULT NULL,
	OriginStateFips      CHAR(2)       DEFAULT NULL,
	OriginStateName      VARCHAR(48)   DEFAULT NULL,
	OriginWac            INT           NOT NULL,
	DestAirportID        INT           NOT NULL,
	DestAirportSeqID     INT           NOT NULL,
	DestCityMarketID     INT           NOT NULL,
	Dest                 CHAR(3)       NOT NULL,
	DestCityName         VARCHAR(40)   NOT NULL,
	DestState            CHAR(2)       DEFAULT NULL,
	DestStateFips        CHAR(2)       DEFAULT NULL,
	DestStateName        VARCHAR(48)   DEFAULT NULL,
	DestWac              INT           NOT NULL,
	CRSDepTime           INT           NOT NULL,
	DepTime              INT           DEFAULT NULL,
	DepDelay             INT           DEFAULT NULL,
	DepDelayMinutes      INT           DEFAULT NULL,
	DepDel15             BOOLEAN       DEFAULT NULL, -- 0, 1 or null
	DepartureDelayGroups TINYINT       DEFAULT NULL, -- Should have values from -1 to 12, but we also have
                                                     -- records with -2 for some reason, and nulls
	DepTimeBlk           CHAR(9)       NOT NULL,     -- the round-hour time block for departure; these all have
                                                     -- the format "HHMM-HHMM", although in fact these are mostly
                                                     -- round-hour intervals (e.g. 1600-1659) and a single large
                                                     -- block at night, 0000-0559. There are thus effectively
                                                     -- exactly 19 values unless the block scheme is changed
	TaxiOut              SMALLINT      DEFAULT NULL,
	WheelsOff            CHAR(4)       DEFAULT NULL, -- typically time in "hhmm" format, but we do see 
	                                                 -- some junk such as 0-90 
	WheelsOn             CHAR(4)       DEFAULT NULL, -- typically time in "hhmm" format, but we do see 
	                                                 -- some junk such as 0-90 
	TaxiIn               SMALLINT      DEFAULT NULL,
	CRSArrTime           SMALLINT      DEFAULT NULL, -- typically time in "hhmm" format; not known yet to have junk
	ArrTime              SMALLINT      DEFAULT NULL, -- typically time in "hhmm" format; not known yet to have junk
	ArrDelay             SMALLINT      DEFAULT NULL,
	ArrDelayMinutes      SMALLINT      DEFAULT NULL,
	ArrDel15             BOOLEAN       DEFAULT NULL, -- 0, 1 or null
	ArrivalDelayGroups   TINYINT       DEFAULT NULL, -- Should have values from -1 to 12, but we also have
                                                     -- records with -2 for some reason, and nulls
	ArrTimeBlk           CHAR(9)       NOT NULL,     -- see comment for DepTimeBlk - full-hour intervals
	Cancelled            BOOLEAN       NOT NULL,     -- 0 or 1 or null
	CancellationCode     CHAR(1)       DEFAULT NULL, -- 'A','B','C' or 'D'
	Diverted             BOOLEAN       NOT NULL,
	CRSElapsedTime       INT           DEFAULT NULL,
	ActualElapsedTime    INT           DEFAULT NULL,
	AirTime              INT           DEFAULT NULL,
	Flights              INT           NOT NULL,
	Distance             INT           NOT NULL,
	DistanceGroup        TINYINT       NOT NULL,     -- Values between 1 and 11 (maybe 12?)
	CarrierDelay         INT           DEFAULT NULL,
	WeatherDelay         INT           DEFAULT NULL,
	NASDelay             INT           DEFAULT NULL,
	SecurityDelay        INT           DEFAULT NULL,
	LateAircraftDelay    INT           DEFAULT NULL,
	FirstDepTime         CHAR(4)       DEFAULT NULL,
	TotalAddGTime        SMALLINT      DEFAULT NULL, 
	LongestAddGTime      SMALLINT      DEFAULT NULL,
	DivAirportLandings   CHAR(1)       DEFAULT NULL,
	DivReachedDest       CHAR(4)       DEFAULT NULL,
	DivActualElapsedTime SMALLINT      DEFAULT NULL, -- unfortunately, this is specified with fixed precision, despite
                                                     -- being integral just like the non-diverted ActualElapsedTime
	DivArrDelay          SMALLINT      DEFAULT NULL,
	DivDistance          SMALLINT      DEFAULT NULL,
	Div1Airport          CHAR(3)       DEFAULT NULL,
	Div1AirportID        INT           DEFAULT NULL,
	Div1AirportSeqID     INT           DEFAULT NULL,
	Div1WheelsOn         CHAR(4)       DEFAULT NULL,
	Div1TotalGTime       SMALLINT      DEFAULT NULL,
	Div1LongestGTime     SMALLINT      DEFAULT NULL,
	Div1WheelsOff        CHAR(4)       DEFAULT NULL,
	Div1TailNum          VARCHAR(6)    DEFAULT NULL,
	Div2Airport          CHAR(3)       DEFAULT NULL,
	Div2AirportID        INT           DEFAULT NULL,
	Div2AirportSeqID     INT           DEFAULT NULL,
	Div2WheelsOn         CHAR(4)       DEFAULT NULL,
	Div2TotalGTime       SMALLINT      DEFAULT NULL,
	Div2LongestGTime     SMALLINT      DEFAULT NULL,
	Div2WheelsOff        CHAR(4)       DEFAULT NULL,
	Div2TailNum          VARCHAR(6)    DEFAULT NULL,
	Div3Airport          CHAR(3)       DEFAULT NULL,
	Div3AirportID        INT           DEFAULT NULL,
	Div3AirportSeqID     INT           DEFAULT NULL,
	Div3WheelsOn         CHAR(4)       DEFAULT NULL,
	Div3TotalGTime       SMALLINT      DEFAULT NULL,
	Div3LongestGTime     SMALLINT      DEFAULT NULL,
	Div3WheelsOff        CHAR(4)       DEFAULT NULL,
	Div3TailNum          VARCHAR(6)    DEFAULT NULL,
	Div4Airport          CHAR(3)       DEFAULT NULL,
	Div4AirportID        INT           DEFAULT NULL,
	Div4AirportSeqID     INT           DEFAULT NULL,
	Div4WheelsOn         CHAR(4)       DEFAULT NULL,
	Div4TotalGTime       SMALLINT      DEFAULT NULL,
	Div4LongestGTime     SMALLINT      DEFAULT NULL,
	Div4WheelsOff        CHAR(10)      DEFAULT NULL,
	Div4TailNum          VARCHAR(6)    DEFAULT NULL,
	Div5Airport          CHAR(3)       DEFAULT NULL,
	Div5AirportID        INT           DEFAULT NULL,
	Div5AirportSeqID     INT           DEFAULT NULL,
	Div5WheelsOn         CHAR(4)       DEFAULT NULL,
	Div5TotalGTime       SMALLINT      DEFAULT NULL,
	Div5LongestGTime     SMALLINT      DEFAULT NULL,
	Div5WheelsOff        CHAR(4)       DEFAULT NULL,
	Div5TailNum          VARCHAR(6)    DEFAULT NULL
);
