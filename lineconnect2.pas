unit lineconnect2;

interface
uses Classes, SysUtils, Forms, Dialogs, Ingeo_TLB, math;

 function LineConnect(app:IIngeoApplication):boolean;

implementation

  function CalcDistance(x1,y1,x2,y2:double):double;
  begin
    Result:=Sqrt(sqr(x1-x2)+sqr(y1-y2));
  end;

 function AddLineToObject(obj1,obj2:IIngeoMapObject):boolean;
  var cntp1,cntp2:IIngeoContourPart;
  i,mi: Integer;
  d1,d2,d3,d4,cv,x1,y1,x2,y2,x3,y3,x4,y4: double;
  d:array [1..4] of double;
  begin
    cntp1:=nil;cntp2:=nil;
    for i := 0 to obj1.Shapes.Count - 1 do
    begin
      if obj1.Shapes[i].DefineGeometry then
      begin
        cntp1:=obj1.Shapes[i].Contour[0];
        break;
      end;
    end;
    for i := 0 to obj2.Shapes.Count - 1 do
    begin
      if obj2.Shapes[i].DefineGeometry then
      begin
        cntp2:=obj2.Shapes[i].Contour[0];
        break;
      end;
    end;
    cntp1.GetVertex(0,x1,y1,cv);
    cntp1.GetVertex(cntp1.VertexCount-1,x2,y2,cv);
    cntp2.GetVertex(0,x3,y3,cv);
    cntp2.GetVertex(cntp2.VertexCount-1,x4,y4,cv);
    d[1]:=CalcDistance(x1,y1,x3,y3);
    d[2]:=CalcDistance(x1,y1,x4,y4);
    d[3]:=CalcDistance(x2,y2,x3,y3);
    d[4]:=CalcDistance(x2,y2,x4,y4);
    mi:=1;
    for i := 1 to 4 do
    begin
      if d[i]<d[mi] then
        mi:=i;
    end;
    case mi of
    1: begin
         for i := 0 to cntp2.VertexCount - 1 do
         begin
           cntp2.GetVertex(i,x1,y1,cv);
           cntp1.InsertVertex(0,x1,y1,cv);
         end;
       end;
    2: begin
         for i := cntp2.VertexCount-1 downto 0 do
         begin
           cntp2.GetVertex(i,x1,y1,cv);
           cntp1.InsertVertex(0,x1,y1,cv);
         end;

       end;
    3: begin
         for i := 0 to cntp2.VertexCount - 1 do
         begin
           cntp2.GetVertex(i,x1,y1,cv);
           cntp1.InsertVertex(-1,x1,y1,cv);
         end;
       end;
    4: begin
         for i := cntp2.VertexCount-1 downto 0 do
         begin
           cntp2.GetVertex(i,x1,y1,cv);
           cntp1.InsertVertex(-1,x1,y1,cv);
         end;

       end;
    end;


    Result:=true;
  end;


  function TestDistance(obj1,obj2:IIngeoMapObject):double;
  var cntp1,cntp2:IIngeoContourPart;
  i: Integer;
  d1,d2,d3,d4,cv,x1,y1,x2,y2,x3,y3,x4,y4: double;
  begin
    cntp1:=nil;cntp2:=nil;
    for i := 0 to obj1.Shapes.Count - 1 do
    begin
      if obj1.Shapes[i].DefineGeometry then
      begin
        cntp1:=obj1.Shapes[i].Contour[0];
        break;
      end;
    end;
    for i := 0 to obj2.Shapes.Count - 1 do
    begin
      if obj2.Shapes[i].DefineGeometry then
      begin
        cntp2:=obj2.Shapes[i].Contour[0];
        break;
      end;
    end;
    cntp1.GetVertex(0,x1,y1,cv);
    cntp1.GetVertex(cntp1.VertexCount-1,x2,y2,cv);
    cntp2.GetVertex(0,x3,y3,cv);
    cntp2.GetVertex(cntp2.VertexCount-1,x4,y4,cv);
    d1:=CalcDistance(x1,y1,x3,y3);
    d2:=CalcDistance(x1,y1,x4,y4);
    d3:=CalcDistance(x2,y2,x3,y3);
    d4:=CalcDistance(x2,y2,x4,y4);
    Result:=Min(Min(d1,d2),Min(d3,d4));
  end;

 function LineConnect(app:IIngeoApplication):boolean;
 var mobjs:IIngeoMapObjects;
  fmobj: IIngeoMapObject;
  i: Integer;
  objl:TInterfaceList;
  mind:double;
  d: double;
  minindex:integer;
  tobj: IIngeoMapObject;
 begin
   if app.Selection.Count=0 then
   begin
     ShowMessage('Не выделен ни один объект!');
     exit;
   end;
   if app.Selection.Count<2 then
   begin
     ShowMessage('Выделено мало объектов!');
     exit;
   end;
   mobjs:=app.ActiveDb.MapObjects;
   fmobj:=mobjs.GetObject(app.Selection.IDs[0]);
   if fmobj.Square<>0 then
   begin
     ShowMessage('Первый выделенный объект замкнут! Нельзя добавлять!');
     exit;
   end;
   objl:=TInterfaceList.Create;
   for i := 1 to app.Selection.Count - 1 do
   begin
     tobj:=mobjs.GetObject(app.Selection.IDs[i]);
     if tobj.Square=0 then
        objl.Add(tobj);
   end;
   while objl.Count>0 do
   begin
     mind:=1e20;
     for i := 0 to objl.Count - 1 do
     begin
       d:=TestDistance(fmobj,objl[i] as IIngeoMapObject);
       if d<mind then
       begin
         minindex:=i;
         mind:=d;
       end;
     end;
     AddLineToObject(fmobj, objl[minindex] as IIngeoMapObject);
     objl.Remove(objl[minindex]);
   end;

   mobjs.UpdateChanges;
end;


end.
