-- This query creates an auxiliary table to the 'ontime' table,
-- with columns correponding to most of the fixed-size CHAR()-type
-- columns of 'on-time': Those columns whose number of characters
-- is at most 4. They're recast as numbers - with the same 
-- in-memory values as the character sequence as the original,
-- assuming a little-endian machine - to facilitate compression,
-- as we do not properly support string input via MonetDB at
-- the moment.
--
-- Note: The second query is very heavy on MonetDB and may well
-- a long time.

CREATE TABLE ontime_casts (

CancellationCode     TINYINT   DEFAULT NULL, 
DivAirportLandings   TINYINT   DEFAULT NULL,

UniqueCarrier        SMALLINT  NOT NULL,
Carrier              SMALLINT  NOT NULL,
OriginState          SMALLINT  DEFAULT NULL,
OriginStateFips      SMALLINT  DEFAULT NULL,
DestState            SMALLINT  DEFAULT NULL,
DestStateFips        SMALLINT  DEFAULT NULL,

Origin               INT       NOT NULL,
Dest                 INT       NOT NULL,
Div1Airport          INT       DEFAULT NULL,
Div2Airport          INT       DEFAULT NULL,
Div3Airport          INT       DEFAULT NULL,
Div4Airport          INT       DEFAULT NULL,
Div5Airport          INT       DEFAULT NULL,

WheelsOff            INT       DEFAULT NULL,
WheelsOn             INT       DEFAULT NULL, 
FirstDepTime         INT       DEFAULT NULL,
DivReachedDest       INT       DEFAULT NULL,
Div1WheelsOn         INT       DEFAULT NULL,
Div1WheelsOff        INT       DEFAULT NULL,
Div2WheelsOn         INT       DEFAULT NULL,
Div2WheelsOff        INT       DEFAULT NULL,
Div3WheelsOn         INT       DEFAULT NULL,
Div3WheelsOff        INT       DEFAULT NULL,
Div4WheelsOn         INT       DEFAULT NULL,
Div4WheelsOff        INT       DEFAULT NULL,
Div5WheelsOn         INT       DEFAULT NULL,
Div5WheelsOff        INT       DEFAULT NULL
);

INSERT INTO ontime_casts SELECT

ascii(substr(CancellationCode,   1,1)) AS CancellationCode,
ascii(substr(DivAirportLandings, 1,1)) AS DivAirportLandings,

ascii(substr(UniqueCarrier,   2,1)) + 256 * ( ascii(substr(UniqueCarrier,   1,1)) ) AS UniqueCarrier,
ascii(substr(Carrier,         2,1)) + 256 * ( ascii(substr(Carrier,         1,1)) ) AS Carrier,
ascii(substr(OriginState,     2,1)) + 256 * ( ascii(substr(OriginState,     1,1)) ) AS OriginState,
ascii(substr(OriginStateFips, 2,1)) + 256 * ( ascii(substr(OriginStateFips, 1,1)) ) AS OriginStateFips,
ascii(substr(DestState,       2,1)) + 256 * ( ascii(substr(DestState,       1,1)) ) AS DestState,
ascii(substr(DestStateFips,   2,1)) + 256 * ( ascii(substr(DestStateFips,   1,1)) ) AS DestStateFips,

ascii(substr(Origin,       3,1)) + 256 * ( ascii(substr(Origin,       2,1)) + 256 * ( ascii(substr(Origin,      1,1)) ) ) AS Origin,
ascii(substr(Dest,         3,1)) + 256 * ( ascii(substr(Dest,         2,1)) + 256 * ( ascii(substr(Dest,        1,1)) ) ) AS Dest,
ascii(substr(Div1Airport,  3,1)) + 256 * ( ascii(substr(Div1Airport,  2,1)) + 256 * ( ascii(substr(Div1Airport, 1,1)) ) ) AS Div1Airport,
ascii(substr(Div2Airport,  3,1)) + 256 * ( ascii(substr(Div2Airport,  2,1)) + 256 * ( ascii(substr(Div2Airport, 1,1)) ) ) AS Div2Airport,
ascii(substr(Div3Airport,  3,1)) + 256 * ( ascii(substr(Div3Airport,  2,1)) + 256 * ( ascii(substr(Div3Airport, 1,1)) ) ) AS Div3Airport,
ascii(substr(Div4Airport,  3,1)) + 256 * ( ascii(substr(Div4Airport,  2,1)) + 256 * ( ascii(substr(Div4Airport, 1,1)) ) ) AS Div4Airport,
ascii(substr(Div5Airport,  3,1)) + 256 * ( ascii(substr(Div5Airport,  2,1)) + 256 * ( ascii(substr(Div5Airport, 1,1)) ) ) AS Div5Airport,

ascii(substr(WheelsOff,      4,1)) + 256 * ( ascii(substr(WheelsOff,      3,1)) + 256 * ( ascii(substr(WheelsOff,      2,1)) + 256 * ( ascii(substr(WheelsOff,      1,1)) ) ) ) AS WheelsOff,
ascii(substr(WheelsOn,       4,1)) + 256 * ( ascii(substr(WheelsOn,       3,1)) + 256 * ( ascii(substr(WheelsOn,       2,1)) + 256 * ( ascii(substr(WheelsOn,       1,1)) ) ) ) AS WheelsOn,
ascii(substr(FirstDepTime,   4,1)) + 256 * ( ascii(substr(FirstDepTime,   3,1)) + 256 * ( ascii(substr(FirstDepTime,   2,1)) + 256 * ( ascii(substr(FirstDepTime,   1,1)) ) ) ) AS FirstDepTime,
ascii(substr(DivReachedDest, 4,1)) + 256 * ( ascii(substr(DivReachedDest, 3,1)) + 256 * ( ascii(substr(DivReachedDest, 2,1)) + 256 * ( ascii(substr(DivReachedDest, 1,1)) ) ) ) AS DivReachedDest,
ascii(substr(Div1WheelsOff,  4,1)) + 256 * ( ascii(substr(Div1WheelsOff,  3,1)) + 256 * ( ascii(substr(Div1WheelsOff,  2,1)) + 256 * ( ascii(substr(Div1WheelsOff,  1,1)) ) ) ) AS Div1WheelsOff,
ascii(substr(Div1WheelsOn,   4,1)) + 256 * ( ascii(substr(Div1WheelsOn,   3,1)) + 256 * ( ascii(substr(Div1WheelsOn,   2,1)) + 256 * ( ascii(substr(Div1WheelsOn,   1,1)) ) ) ) AS Div1WheelsOn,
ascii(substr(Div2WheelsOff,  4,1)) + 256 * ( ascii(substr(Div2WheelsOff,  3,1)) + 256 * ( ascii(substr(Div2WheelsOff,  2,1)) + 256 * ( ascii(substr(Div2WheelsOff,  1,1)) ) ) ) AS Div2WheelsOff,
ascii(substr(Div2WheelsOn,   4,1)) + 256 * ( ascii(substr(Div2WheelsOn,   3,1)) + 256 * ( ascii(substr(Div2WheelsOn,   2,1)) + 256 * ( ascii(substr(Div2WheelsOn,   1,1)) ) ) ) AS Div2WheelsOn,
ascii(substr(Div3WheelsOff,  4,1)) + 256 * ( ascii(substr(Div3WheelsOff,  3,1)) + 256 * ( ascii(substr(Div3WheelsOff,  2,1)) + 256 * ( ascii(substr(Div3WheelsOff,  1,1)) ) ) ) AS Div3WheelsOff,
ascii(substr(Div3WheelsOn,   4,1)) + 256 * ( ascii(substr(Div3WheelsOn,   3,1)) + 256 * ( ascii(substr(Div3WheelsOn,   2,1)) + 256 * ( ascii(substr(Div3WheelsOn,   1,1)) ) ) ) AS Div3WheelsOn,
ascii(substr(Div4WheelsOff,  4,1)) + 256 * ( ascii(substr(Div4WheelsOff,  3,1)) + 256 * ( ascii(substr(Div4WheelsOff,  2,1)) + 256 * ( ascii(substr(Div4WheelsOff,  1,1)) ) ) ) AS Div4WheelsOff,
ascii(substr(Div4WheelsOn,   4,1)) + 256 * ( ascii(substr(Div4WheelsOn,   3,1)) + 256 * ( ascii(substr(Div4WheelsOn,   2,1)) + 256 * ( ascii(substr(Div4WheelsOn,   1,1)) ) ) ) AS Div4WheelsOn,
ascii(substr(Div5WheelsOff,  4,1)) + 256 * ( ascii(substr(Div5WheelsOff,  3,1)) + 256 * ( ascii(substr(Div5WheelsOff,  2,1)) + 256 * ( ascii(substr(Div5WheelsOff,  1,1)) ) ) ) AS Div5WheelsOff,
ascii(substr(Div5WheelsOn,   4,1)) + 256 * ( ascii(substr(Div5WheelsOn,   3,1)) + 256 * ( ascii(substr(Div5WheelsOn,   2,1)) + 256 * ( ascii(substr(Div5WheelsOn,   1,1)) ) ) ) AS Div5WheelsOn

FROM ontime;

