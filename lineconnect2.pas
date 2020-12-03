unit lineconnect2;

interface
uses Classes, SysUtils, Forms, Dialogs, Ingeo_TLB, math;

const maxdist:double=0.01;
 function LineConnect(app:IIngeoApplication):boolean;
 function LineConnect3(app:IIngeoApplication):boolean;

implementation

  function CalcDistance(x1,y1,x2,y2:double):double;
  begin
    Result:=Sqrt(sqr(x1-x2)+sqr(y1-y2));
  end;

  procedure GetPoints(obj:IIngeoMapObject;var x1,y1,x2,y2:double);
  var cv:double;
  cntr: IIngeoContourPart;
  begin
    cntr:=obj.Shapes[0].Contour[0];
    cntr.GetVertex(0,x1,y1,cv);
    cntr.GetVertex(cntr.VertexCount-1,x2,y2,cv);
  end;

 function CanConnect(obj:IIngeoMapObject;x1,y1,x2,y2:double):boolean;
 var x3,y3,x4,y4:double;
 begin
   Result:=false;
   GetPoints(obj,x3,y3,x4,y4);
   Result:=   (CalcDistance(x1,y1,x3,y3)<maxdist) or
              (CalcDistance(x2,y2,x3,y3)<maxdist) or
              (CalcDistance(x1,y1,x4,y4)<maxdist) or
              (CalcDistance(x2,y2,x4,y4)<maxdist);
 end;

 procedure ConnectObject(obj1,obj2:IIngeoMapObject);
 var x1,y1,x2,y2,x3,y3,x4,y4,xx,yy,cc:double;
  i: Integer;
  z: Integer;
 begin
   GetPoints(obj1,x1,y1,x2,y2);
   GetPoints(obj2,x3,y3,x4,y4);
   if CalcDistance(x2,y2,x3,y3)<maxdist then
   begin
     for i := 1 to obj2.Shapes[0].Contour[0].VertexCount - 1 do
     begin
       obj2.Shapes[0].Contour[0].GetVertex(i,xx,yy,cc);
       obj1.Shapes[0].Contour[0].InsertVertex(-1,xx,yy,cc);
     end;
     exit;
   end;
   if CalcDistance(x1,y1,x4,y4)<maxdist then
   begin
     for i := 0 to obj2.Shapes[0].Contour[0].VertexCount - 2 do
     begin
       obj2.Shapes[0].Contour[0].GetVertex(i,xx,yy,cc);
       obj1.Shapes[0].Contour[0].InsertVertex(i,xx,yy,cc);
     end;
     exit;
   end;

   if CalcDistance(x1,y1,x3,y3)<maxdist then
   begin
     for i :=1 to obj2.Shapes[0].Contour[0].VertexCount - 1 do
     begin
       obj2.Shapes[0].Contour[0].GetVertex(i,xx,yy,cc);
       obj1.Shapes[0].Contour[0].InsertVertex(0,xx,yy,cc);
     end;
     exit;
   end;

   if CalcDistance(x2,y2,x4,y4)<maxdist then
   begin
     z:=obj1.Shapes[0].Contour[0].VertexCount;
     for i :=0 to obj2.Shapes[0].Contour[0].VertexCount - 2 do
     begin
       obj2.Shapes[0].Contour[0].GetVertex(i,xx,yy,cc);
       obj1.Shapes[0].Contour[0].InsertVertex(z-1,xx,yy,cc);
     end;
     exit;
   end;

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

 function LineConnect3(app:IIngeoApplication):boolean;
 var mobjs:IIngeoMapObjects;
  fmobj: IIngeoMapObject;
  i: Integer;
  objl:TInterfaceList;
  mind:double;
  d,x1,y1,x2,y2: double;
  minindex:integer;
  tobj: IIngeoMapObject;
  objlist:TInterfaceList;
  mobj: IIngeoMapObject;
  connected: Boolean;

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
   //set src contour list - exclude closed, multishaped, multicontour
   //first contour - find connected - connect - exclude connected
   //only first shape
   //only first contour
   mobjs:=app.ActiveDb.MapObjects;
   objlist:=TInterfaceList.Create;
   for i := 0 to app.Selection.Count - 1 do
     begin
       mobj:=mobjs.GetObject(app.Selection.IDs[i]);
       if mobj.Shapes.Count>1 then
         continue;
       if mobj.Shapes[0].Contour.Count>1 then
         continue;
       if mobj.Shapes[0].Contour[0].Closed then
         continue;
       if mobj.Shapes[0].Contour[0].VertexCount<2 then
         continue;

       objlist.Add(mobj);
     end;
   app.Selection.DeselectAll;
   while True do
   begin
     if objlist.Count=1 then
       break;
     mobj:=objlist[0] as IIngeoMapObject;
     GetPoints(mobj,x1,y1,x2,y2);
     connected:=false;
     for i := 1 to objlist.Count - 1 do
     begin
       if CanConnect(objlist[i] as IIngeoMapObject,x1,y1,x2,y2) then
       begin
         ConnectObject(mobj,objlist[i] as IIngeoMapObject);
         app.Selection.Select((objlist[i] as IIngeoMapObject).ID,-1);

         objlist.Delete(i);
         connected:=true;
         break;
       end;
     end;
     if not connected then
       objlist.Delete(0);
   end;

   mobjs.UpdateChanges;
end;


end.
