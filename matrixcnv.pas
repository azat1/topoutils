unit matrixcnv;

interface
uses Classes,Math;

type TMatrixConverter=class
        public
          a1,a2,a3,a4,a5,a6,a7,a8,a9:double;
          b1,b2,b3,b4,b5,b6,b7,b8,b9:double;
          constructor Create(wx1,wy1,wx2,wy2,wx3,wy3:double;x1,y1,x2,y2,x3,y3:integer);
          procedure PointW2D(wx,wy:double;var dx,dy:integer);
          procedure PointD2W(x,y:integer;var wx,wy:double);
     end;
implementation

{ TMatrixConverter }

constructor TMatrixConverter.Create(wx1, wy1, wx2, wy2, wx3, wy3: double; x1,
  y1, x2, y2, x3, y3: integer);
begin

end;

procedure TMatrixConverter.PointD2W(x, y: integer; var wx, wy: double);
begin

end;

procedure TMatrixConverter.PointW2D(wx, wy: double; var dx, dy: integer);
begin

end;

end.
