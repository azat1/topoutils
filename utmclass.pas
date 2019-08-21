unit utmclass;

interface
uses Math;

const
  sk42a=6378245.0;
  sk42b=6356863.01877;
  wgsa=6378137;
  wgsb=6356752.314;
  datumPuk42=1;
  datumWGS84=0;

type
   TUTMConverter=class
     public
       ea,eb,fscale:extended;
       eccsq:extended;
       cmer,fx,fy:extended;
       datum:integer;
       constructor Create(adatum:integer;acmer,afx,afy,ascale:extended);
       function ArcLengthOfMeridian(phi:extended):extended;
       function UTMCentralMeridian(zone:extended):extended;
       function FootPointLatitude(y:extended):extended;
       procedure MapLatLonToXY(phi,lambda,lambda0:extended;var x,y:extended);
       procedure MapXYToLatLon(x,y,lambda0:extended;var lat,lon:extended);
       procedure LatLonToUTMXY(lat,lon,zone:extended;var x,y:extended);
       procedure UTMXYToLatLon(x,y,zone:extended;south:boolean;var lat,lon:extended);
       procedure XY2LatLon(x,y:extended;var lat,lon:extended);
       procedure LatLon2XY(lat,lon:extended;var x,y:extended);
   end;
   TDatumConverter=class
     public
       ro,ap,alp,e2p,aw,alw,e2w,a,e2,da,de2:extended;
       dx,dy,dz,wx,wy,wz,ms:extended;
       src,dest:integer;
       constructor Create(sdatum,ddatum:integer);
       function WGS84_SK42_Lat(Bd, Ld, H:extended):extended;
       function SK42_WGS84_Lat(Bd, Ld, H:extended):extended;
       Function WGS84_SK42_Long(Bd, Ld, H:extended):Double;
       Function SK42_WGS84_Long(Bd, Ld, H:extended):extended;
       Function dB(Bd, Ld, H:extended):extended;
       Function dL(Bd, Ld, H:extended):extended;
       Function WGS84Alt(Bd, Ld, H:extended):extended;
       procedure Convert(slat,slon:extended;var dlat,dlon:extended);
   end;
implementation
//uses math;
{ TUTMConverter }

function TUTMConverter.ArcLengthOfMeridian(phi: extended): extended;
var alpha,beta,gamma,delta,epsilon,n:extended;
begin
  n:=(ea-eb)/(ea+eb);
  alpha:= ((ea + eb) / 2.0)
           * (1.0 + (Math.Power (n, 2.0) / 4.0) + (Math.power (n, 4.0) / 64.0));
  beta := (-3.0 * n / 2.0) + (9.0 * Math.power (n, 3.0) / 16.0)
           + (-3.0 * Math.power (n, 5.0) / 32.0);
  gamma := (15.0 * Math.power (n, 2.0) / 16.0)
           + (-15.0 * Math.power (n, 4.0) / 32.0);
  delta := (-35.0 * Math.power (n, 3.0) / 48.0)
            + (105.0 * Math.power (n, 5.0) / 256.0);
  epsilon := (315.0 * Math.power (n, 4.0) / 512.0);
  result := alpha
        * (phi + (beta * sin (2.0 * phi))
            + (gamma * sin (4.0 * phi))
            + (delta * sin (6.0 * phi))
            + (epsilon * sin (8.0 * phi)));


end;

constructor TUTMConverter.Create(adatum:integer;acmer,afx,afy,ascale:extended);
begin
  datum:=adatum;
  case datum of
  datumPuk42:
    begin
      ea:=sk42a;
      eb:=sk42b;
    end;
  datumWGS84:
    begin
      ea:=wgsa;
      eb:=wgsb;
    end;
  end;
  fscale:=ascale;
  eccsq:=(ea*ea-eb*eb)/(ea*ea);
  fx:=afx;
  fy:=afy;
  cmer:=acmer;
end;

function TUTMConverter.FootPointLatitude(y: extended): extended;
var y_,alpha_,beta_,gamma_,delta_,epsilon_,n:extended;

begin
  n:=(ea-eb)/(ea+eb);
  alpha_ := ((ea + eb) / 2.0)
            * (1 + (Math.power (n, 2.0) / 4) + (Math.power (n, 4.0) / 64));
  y_ := y / alpha_;
  beta_ := (3.0 * n / 2.0) + (-27.0 * Math.power (n, 3.0) / 32.0)
            + (269.0 * Math.power (n, 5.0) / 512.0);
  gamma_ := (21.0 * Math.power (n, 2.0) / 16.0)
            + (-55.0 * Math.power (n, 4.0) / 32.0);
  delta_ := (151.0 * Math.power (n, 3.0) / 96.0)
            + (-417.0 * Math.power (n, 5.0) / 128.0);
  epsilon_ := (1097.0 * Math.power (n, 4.0) / 512.0);
  result := y_ + (beta_ * sin (2.0 * y_))
            + (gamma_ * sin (4.0 * y_))
            + (delta_ * sin (6.0 * y_))
            + (epsilon_ * sin (8.0 * y_));
end;

procedure TUTMConverter.LatLon2XY(lat, lon: extended; var x, y: extended);
begin
  MapLatLonToXY(lat,lon,cmer,x,y);
  x:=x*fscale+fx;
  y:=y*fscale+fy;
end;

procedure TUTMConverter.LatLonToUTMXY(lat, lon, zone: extended; var x,
  y: extended);
begin
  MapLatLonToXY (lat, lon, UTMCentralMeridian (zone), x,y);
  x := x * fscale + 500000.0;
  y := y * fscale;
        if (y < 0.0) then
            y := y + 10000000.0;


end;

procedure TUTMConverter.MapLatLonToXY(phi, lambda, lambda0: extended; var x,
  y: extended);
var n,nu2,ep2,t,t2,l:extended;
    l3coef,l4coef,l5coef,l6coef,l7coef,l8coef:extended;
    tmp:extended;
begin
  ep2 := (Math.power (ea, 2.0) - Math.power (eb, 2.0)) / Math.power (eb, 2.0);
  nu2 := ep2 * Math.power (cos (phi), 2.0);
  N := Math.power (ea, 2.0) / (eb * sqrt (1 + nu2));
  t := Math.tan (phi);
  t2 := t * t;
  tmp := (t2 * t2 * t2) - Math.power (t, 6.0);
  l := lambda - lambda0;
        l3coef := 1.0 - t2 + nu2;

        l4coef := 5.0 - t2 + 9 * nu2 + 4.0 * (nu2 * nu2);

        l5coef := 5.0 - 18.0 * t2 + (t2 * t2) + 14.0 * nu2
            - 58.0 * t2 * nu2;

        l6coef := 61.0 - 58.0 * t2 + (t2 * t2) + 270.0 * nu2
            - 330.0 * t2 * nu2;

        l7coef := 61.0 - 479.0 * t2 + 179.0 * (t2 * t2) - (t2 * t2 * t2);

        l8coef := 1385.0 - 3111.0 * t2 + 543.0 * (t2 * t2) - (t2 * t2 * t2);
    x := N * cos (phi) * l
            + (N / 6.0 * Math.power (cos (phi), 3.0) * l3coef * Math.power (l, 3.0))
            + (N / 120.0 * Math.power (cos (phi), 5.0) * l5coef * Math.power (l, 5.0))
            + (N / 5040.0 * Math.power (cos (phi), 7.0) * l7coef * Math.power (l, 7.0));
    y := ArcLengthOfMeridian (phi)
            + (t / 2.0 * N * Math.power (cos (phi), 2.0) * Math.power (l, 2.0))
            + (t / 24.0 * N * Math.power (cos (phi), 4.0) * l4coef * Math.power (l, 4.0))
            + (t / 720.0 * N * Math.power (cos (phi), 6.0) * l6coef * Math.power (l, 6.0))
            + (t / 40320.0 * N * Math.power (cos (phi), 8.0) * l8coef * Math.power (l, 8.0));


end;

procedure TUTMConverter.MapXYToLatLon(x, y, lambda0: extended; var lat,
  lon: extended);
var phif, Nf, Nfpow, nuf2, ep2, tf, tf2, tf4, cf:extended;
    x1frac, x2frac, x3frac, x4frac, x5frac, x6frac, x7frac, x8frac:extended;
    x2poly, x3poly, x4poly, x5poly, x6poly, x7poly, x8poly:extended;
begin
  phif := FootpointLatitude (y);
  ep2 := (Math.power (ea, 2.0) - Math.power (eb, 2.0))
              / Math.power (eb, 2.0);
  cf := cos (phif);
  nuf2 := ep2 * Math.power (cf, 2.0);
   Nf := Math.power (ea, 2.0) / (eb * sqrt (1 + nuf2));
  Nfpow := Nf;
  tf := Math.tan (phif);
  tf2 := tf * tf;
  tf4 := tf2 * tf2;
        x1frac := 1.0 / (Nfpow * cf);
        
        Nfpow :=Nfpow* Nf;   //* now equals Nf**2) */
        x2frac := tf / (2.0 * Nfpow);

        Nfpow :=Nfpow* Nf;   //* now equals Nf**3) */
        x3frac := 1.0 / (6.0 * Nfpow * cf);

        Nfpow :=Nfpow* Nf;   //* now equals Nf**4) */
        x4frac := tf / (24.0 * Nfpow);

        Nfpow :=Nfpow* Nf;   //* now equals Nf**5) */
        x5frac := 1.0 / (120.0 * Nfpow * cf);

        Nfpow := Nfpow*Nf;   //* now equals Nf**6) */
        x6frac := tf / (720.0 * Nfpow);

        Nfpow := Nfpow*Nf;   //* now equals Nf**7) */
        x7frac := 1.0 / (5040.0 * Nfpow * cf);

        Nfpow := Nfpow*Nf;   //* now equals Nf**8) */
        x8frac := tf / (40320.0 * Nfpow);
        x2poly := -1.0 - nuf2;

        x3poly := -1.0 - 2 * tf2 - nuf2;

        x4poly := 5.0 + 3.0 * tf2 + 6.0 * nuf2 - 6.0 * tf2 * nuf2
        	- 3.0 * (nuf2 *nuf2) - 9.0 * tf2 * (nuf2 * nuf2);

        x5poly := 5.0 + 28.0 * tf2 + 24.0 * tf4 + 6.0 * nuf2 + 8.0 * tf2 * nuf2;

        x6poly := -61.0 - 90.0 * tf2 - 45.0 * tf4 - 107.0 * nuf2
        	+ 162.0 * tf2 * nuf2;

        x7poly := -61.0 - 662.0 * tf2 - 1320.0 * tf4 - 720.0 * (tf4 * tf2);

        x8poly := 1385.0 + 3633.0 * tf2 + 4095.0 * tf4 + 1575 * (tf4 * tf2);
        lat := phif + x2frac * x2poly * (x * x)
        	+ x4frac * x4poly * Math.power (x, 4.0)
        	+ x6frac * x6poly * Math.power (x, 6.0)
        	+ x8frac * x8poly * Math.power (x, 8.0);
        lon:= lambda0 + x1frac * x
        	+ x3frac * x3poly * Math.power (x, 3.0)
        	+ x5frac * x5poly * Math.power (x, 5.0)
        	+ x7frac * x7poly * Math.power (x, 7.0);


end;

function TUTMConverter.UTMCentralMeridian(zone: extended): extended;
begin
  REsult:=DegToRad(-183+zone*6);

end;

procedure TUTMConverter.UTMXYToLatLon(x, y, zone: extended; south: boolean;
  var lat, lon: extended);
var cmeridian:extended;
begin
        x :=x- 500000.0;
        x:= x/ fscale;
       if (south) then
           y :=y- 10000000.0;
        y :=y/ fscale;
        cmeridian := UTMCentralMeridian (zone);
        MapXYToLatLon (x, y, cmeridian, lat,lon);



end;

procedure TUTMConverter.XY2LatLon(x, y: extended; var lat, lon: extended);
begin
  x:=x-fx;
  y:=y-fy;
  x:=x/fscale;
  y:=y/fscale;
  MapXYToLatLon(x,y,cmer,lat,lon);
end;

{ TDatumConverter }

procedure TDatumConverter.Convert(slat, slon: extended; var dlat,
  dlon: extended);
begin

  if src=dest then
  begin
    dlat:=slat;
    dlon:=slon;
    exit;
  end;
  if (src=datumPuk42) and (dest=datumWGS84) then
  BEGIN
    dlat:=SK42_WGS84_Lat(slat*180/pi,slon*180/pi,0)/180*pi;
    dlon:=SK42_WGS84_Long(slat*180/pi,slon*180/pi,0)/180*pi;
    exit;
  end;
  if (src=datumWGS84) and (dest=datumPuk42) then
  BEGIN
    dlat:=WGS84_SK42_Lat(slat*180/pi,slon*180/pi,0)/180*pi;
    dlon:=WGS84_SK42_Long(slat*180/pi,slon*180/pi,0)/180*pi;
    exit;
  end;

end;

constructor TDatumConverter.Create(sdatum, ddatum: integer);
begin
  src:=sdatum;
  dest:=ddatum;
  ro := 206264.8062; // Число угловых секунд в радиане

// Эллипсоид Красовского
 ap := 6378245; // Большая полуось
 alP := 1 / 298.3; // Сжатие
 e2P := 2 * alP - alP *alp; // Квадрат эксцентриситета

// Эллипсоид WGS84 (GRS80, эти два эллипсоида сходны по большинству параметров)
 aW := 6378137; // Большая полуось
 alW := 1 / 298.257223563; // Сжатие
 e2W := 2 * alW - alW * alw; // Квадрат эксцентриситета

// Вспомогательные значения для преобразования эллипсоидов
 a := (aP + aW) / 2;
 e2 := (e2P + e2W) / 2;
 da := aW - aP;
 de2 := e2W - e2P;

// Линейные элементы трансформирования, в метрах
 dx := 23.92;
 dy := -141.27;
 dz := -80.9;
// Угловые элементы трансформирования, в секундах
 wx := 0;
 wy := 0 ;
 wz := 0;
// Дифференциальное различие масштабов
 ms := 0;

end;

function TDatumConverter.dB(Bd, Ld, H: extended): extended;
var B, L, M, N:extended;
begin
B := Bd * Pi / 180;
L := Ld * Pi / 180;
M := a * (1 - e2) / Math.Power( (1 - e2 *  Math.Power(sin(B) , 2)) , 1.5);
N := a * Power((1 - e2 * Power( Sin(B) , 2)) , -0.5);
dB := ro / (M + H) * (N / a * e2 * Sin(B) * Cos(B) * da
    + (N * N / (a *a) + 1) * N * Sin(B) * Cos(B) * de2 / 2
 - (dx * Cos(L) + dy * Sin(L)) * Sin(B) + dz * Cos(B))
  - wx * Sin(L) * (1 + e2 * Cos(2 * B))
   + wy * Cos(L) * (1 + e2 * Cos(2 * B))  - ro * ms * e2 * Sin(B) * Cos(B);

end;

function TDatumConverter.dL(Bd, Ld, H: extended): extended;
var B, L, N:extended;
begin
B := Bd * Pi / 180;
L := Ld * Pi / 180;
N := a * Power( (1 - e2 * Power(Sin(B) , 2)) , -0.5);
dL := ro / ((N + H) * Cos(B)) * (-dx * Sin(L) + dy * Cos(L))
 + Tan(B) * (1 - e2) * (wx * Cos(L) + wy * Sin(L)) - wz;

end;

function TDatumConverter.SK42_WGS84_Lat(Bd, Ld, H: extended): extended;
begin
  SK42_WGS84_Lat := Bd + dB(Bd, Ld, H) / 3600;
end;

function TDatumConverter.SK42_WGS84_Long(Bd, Ld, H: extended): extended;
begin
SK42_WGS84_Long := Ld + dL(Bd, Ld, H) / 3600;

end;

function TDatumConverter.WGS84Alt(Bd, Ld, H: extended): extended;
var B, L, N, dH:extended;
begin
B := Bd * Pi / 180;
L := Ld * Pi / 180;
N := a * power( (1 - e2 * Power( Sin(B) , 2)) , -0.5);
dH := -a / N * da + N * power( Sin(B) , 2) * de2 / 2
  + (dx * Cos(L) + dy * Sin(L)) * Cos(B) + dz * Sin(B)
  - N * e2 * Sin(B) * Cos(B) * (wx / ro * Sin(L) - wy / ro * Cos(L))
   + (a  *a / N + H) * ms;
WGS84Alt := H + dH;

end;

function TDatumConverter.WGS84_SK42_Lat(Bd, Ld, H: extended): extended;
begin
  WGS84_SK42_Lat := Bd - dB(Bd, Ld, H) / 3600;

end;

function TDatumConverter.WGS84_SK42_Long(Bd, Ld, H: extended): Double;
begin
  WGS84_SK42_Long := Ld - dL(Bd, Ld, H) / 3600;

end;

end.
