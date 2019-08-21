unit thclass;

interface
uses Classes,xmlintf ,xmldoc;
const
   ptSource=1;
   ptWork=2;

   atRight=1;
   atLeft=2;

   telTeoHod=1;
   telNivHod=2;
type

   THPoint=class
     public
       name:string;
       x,y,z:double;
       cx,cy,cz:double;
       ptype:integer;
       constructor Create(aname:string;ax,ay,az:double;aptype:integer);
       procedure Save(node:IXMLNode);
       procedure Load(node:IXMLNode);
       procedure ChangePointType;
   end;

   THVector=class
     public
       fp:THPoint;
       measdist,measangle:double;
       corrangle,corrdist:double;
       angletype:integer;
       finalized:boolean;
       constructor Create(afp:THPoint;ameasdist,ameasangle:double;aangletype:integer);
       constructor CreateFromNode(node:IXMLNode);
       procedure SaveToNode(node:IXMLNode);
   end;

   THVectorList=class(TList)
     public
       name:string;
       fp,sp:THPoint;
       constructor Create(aname:string);
       function GetVector(i:integer):THVector;
       procedure Save(node:IXMLNode);
       procedure Load(node:IXMLNode);
   end;

   THPointList=class(TList)
     public
       function GetPoint(i:integer):THPoint;
       function GetPointByName(name:string):THPoint;
       procedure Save(node:IXMLNode);
       procedure Load(node:IXMLNode);
   end;

   THHVList=class(TList)
     public
       function GetVL(i:integer):THVectorList;
       procedure Save(node:IXMLNode);
       procedure Load(node:IXMLNode);
   end;

   THH=class
     public
       objectlist:TList;
       filename:string;
       constructor Create;
       procedure Adjust;
       procedure Save(fname:string);
       procedure Load(fname:string);
       procedure SaveSetup(node:IXMLNode);
       procedure LoadSetup(node:IXMLNode);
   end;

   THHList=class(TList)
     public

   end;

   THElement=class
     public
       name:string;
       elementtype:integer;
       procedure SaveToNode(node:IXMLNode);virtual; abstract;
       procedure LoadFromNode(node:IXMLNode);virtual; abstract;
   end;

   THTeoHod=class(THElement)
     public
       vectorlist:THVectorList;
       constructor Create;
       procedure SaveToNode(node:IXMLNode);override;
       procedure LoadFromNode(node:IXMLNode);override;
   end;

   THNivVectorList=class(TList)

   end;
   THNivHod=class(THElement)
     public
       vectorlist:THNivVectorList;
       constructor Create;
       procedure SaveToNode(node:IXMLNode);override;
       procedure LoadFromNode(node:IXMLNode);override;
   end;

   var globalpoints:THPointList;
   function AngleToStr(angle:double):string;
   function StrToAngle(str:string):double;
   function PointTypeToStr(pt:integer):string;
implementation
uses SysUtils;

   function PointTypeToStr(pt:integer):string;
   begin
     Result:='Неизвестный';
     case pt of
       ptSource:Result:='Исходный';
       ptWork:Result:='Рабочий';
     end;
   end;

   function AngleToStr(angle:double):string;
   var ts,g,m,s:integer;

   begin
     g:=Round(int(angle));
     ts:=Round(frac(angle)*3600);
     m:=ts div 60;
     s:=ts mod 60;
     Result:=Format('%d %d'' %d"',[g,m,s]);
   end;

   function StrToAngle(str:string):double;
   begin
     Result:=0;
   end;

{ THPoint }

procedure THPoint.ChangePointType;
begin
  if ptype=ptSource then
    ptype:=ptWork else ptype:=ptSource;
end;

constructor THPoint.Create(aname: string; ax, ay, az: double; aptype: integer);
begin
  inherited Create;
  name:=aname;x:=ax;y:=ay;z:=az;ptype:=aptype;
  cx:=0;cy:=0;cz:=0;
end;

procedure THPoint.Load(node: IXMLNode);
begin
  name:=node.GetAttributeNS('NAME','');
  x:=node.GetAttributeNS('X','');
  y:=node.GetAttributeNS('Y','');
  z:=node.GetAttributeNS('H','');

  cx:=node.GetAttributeNS('CX','');
  cy:=node.GetAttributeNS('CY','');
  cz:=node.GetAttributeNS('CH','');

  ptype:=node.GetAttributeNS('PTYPE','');

end;

procedure THPoint.Save(node: IXMLNode);
begin
  node.SetAttributeNS('NAME','',name);
  node.SetAttributeNS('X','',x);
  node.SetAttributeNS('Y','',y);
  node.SetAttributeNS('H','',z);

  node.SetAttributeNS('CX','',cx);
  node.SetAttributeNS('CY','',cy);
  node.SetAttributeNS('CH','',cz);

  node.SetAttributeNS('PTYPE','',ptype);

end;

{ THVector }

constructor THVector.Create(afp: THPoint; ameasdist,
  ameasangle: double;aangletype:integer);
begin
  inherited Create;
  fp:=afp;
  measdist:=ameasdist;
  measangle:=ameasangle;
  corrdist:=0;
  corrangle:=0;
  finalized:=false;
end;

constructor THVector.CreateFromNode(node: IXMLNode);
begin
  fp:=globalpoints.GetPointByName(node.GetAttributeNS('fp',''));
  measdist:=node.GetAttributeNS('measdist','');
  measangle:=node.GetAttributeNS('measangle','');
  corrangle:=node.GetAttributeNS('corrangle','');
  corrdist:=node.GetAttributeNS('corrdist','');
  angletype:=node.GetAttributeNS('angletype','');
  finalized:=node.GetAttributeNS('finalized','');
end;

procedure THVector.SaveToNode(node: IXMLNode);
begin
  node.SetAttributeNS('fp','',fp.name);
  node.SetAttributeNS('measdist','',measdist);
  node.SetAttributeNS('measangle','',measangle);
  node.SetAttributeNS('corrdist','',corrdist);
  node.SetAttributeNS('corrangle','',corrangle);
  node.SetAttributeNS('angletype','',angletype);
  node.SetAttributeNS('finalized','',finalized);

end;

{ THVectorList }

constructor THVectorList.Create(aname: string);
begin
  inherited Create;
  name:=aname;
end;

function THVectorList.GetVector(i: integer): THVector;
begin
  Result:=THVector(Items[i]);
end;

procedure THVectorList.Load(node: IXMLNode);
var
  i: Integer;
  v:THVector;
  nv:IXMLNode;
begin
  fp:=globalpoints.GetPointByName( node.GetAttributeNS('fp',''));
  sp:=globalpoints.GetPointByName(node.GetAttributeNS('sp',''));
  for i := 0 to node.childnodes. Count - 1 do
  begin
//    v:=GetVector(i);
    Add( THVector.CreateFromNode(node.ChildNodes.Get(i)));
  end;
end;

procedure THVectorList.Save(node: IXMLNode);
var
  i: Integer;
  v:THVector;
  nv:IXMLNode;
begin
  node.SetAttributeNS('fp','',fp.name);
  node.SetAttributeNS('sp','',sp.name);
  for i := 0 to Count - 1 do
  begin
    v:=GetVector(i);
    nv:=node.AddChild('vector');
    v.SaveToNode(nv);
  end;
end;

{ THPointList }

function THPointList.GetPoint(i: integer): THPoint;
begin
  REsult:=THPoint(Items[i]);
end;

function THPointList.GetPointByName(name: string): THPoint;
var
  i: Integer;
  p: THPoint;
begin
  Result:=nil;
  for i := 0 to Count - 1 do
  begin
    p:=GetPoint(i);
    if  p.name=name then
    begin
      Result:=p;
      exit;
    end;
  end;
end;

procedure THPointList.Load(node: IXMLNode);
var
  i: Integer;
  p:THPoint;
begin
  Clear;
  for i := 0 to node.Childnodes.Count - 1 do
  begin
    p:=THPoint.Create('',0,0,0,0);
    p.Load(node.ChildNodes.Get(i ));
    Add(p);
  end;
end;

procedure THPointList.Save(node: IXMLNode);
var xn:IXMLNode;
    i:integer;
    p:THPoint;
begin
  for i := 0 to Count - 1 do
  begin
    p:=GetPoint(i);
    xn:=node.AddChild('POINT');
    p.Save(xn);
  end;
end;

{ THH }

procedure THH.Adjust;
begin

end;

constructor THH.Create;
begin
  inherited;
  filename:='';
  objectlist:=TList.Create;
end;

procedure THH.Load(fname: string);
var xd:IXMLDocument;
    mainnode,node,el:IXMLNode;
    x:THElement;
  i: Integer;
begin
  xd:=LoadXMLDocument(fname);
  mainnode:=xd.ChildNodes.FindNode('THFILE');
  globalpoints.Load(mainnode.ChildNodes.FindNode('POINTS'));
  node:=mainnode.ChildNodes.FindNode('ELEMENTS');
  for i := 0 to node.ChildNodes.Count - 1 do
  begin
    el:=node.ChildNodes.Get(i);
    if el.GetAttributeNS('ELTYPE','')=telTeoHod then
    begin
      x:=THTeoHod.Create;
      x.LoadFromNode(el);
      objectlist.Add(x);
    end;
    if el.GetAttributeNS('ELTYPE','')=telNivHod then
    begin
      x:=THNivHod.Create;
      x.LoadFromNode(el);
      objectlist.Add(x);
    end;

  end;
//  hodlist.Load(mainnode.ChildNodes.FindNode('VECTORS'));
  LoadSetup(mainnode.ChildNodes.FindNode('SETUP'));

end;

procedure THH.LoadSetup(node: IXMLNode);
begin

end;

procedure THH.Save(fname: string);
var xd:IXMLDocument;
    elems,mainnode,node:IXMLNode;
  i: Integer;
begin
  xd:=NewXMLDocument();
  mainnode:=xd.AddChild('THFILE');
  globalpoints.Save(mainnode.AddChild('POINTS'));
  elems:=mainnode.AddChild('ELEMENTS');
  for i := 0 to objectlist.Count - 1 do
  begin
    THElement(objectlist[i]).SaveToNode(elems.AddChild('VECTORLIST'));
  end;
  SaveSetup(mainnode.AddChild('SETUP'));
  xd.SaveToFile(fname);
  filename:=fname;
end;

procedure THH.SaveSetup(node: IXMLNode);
begin

end;

{ THHVList }

function THHVList.GetVL(i: integer): THVectorList;
begin
  Result:=THVectorList(Items[i]);
end;

procedure THHVList.Load(node: IXMLNode);
begin

end;

procedure THHVList.Save(node: IXMLNode);
begin

end;

{ THTeoHod }

constructor THTeoHod.Create;
begin
  inherited;
  name:='';
  elementtype:=telTeoHod;
  vectorlist:=THVectorList.Create('');
end;

procedure THTeoHod.LoadFromNode(node: IXMLNode);
var x:IXMLNode;
  i: Integer;
  z:THVector;
begin
  vectorlist.fp:=globalpoints.GetPointByName(node.GetAttributeNS('fp',''));
  vectorlist.sp:=globalpoints.GetPointByName(node.GetAttributeNS('sp',''));
  name:=node.GetAttributeNS('name','');
  for i := 0 to node.ChildNodes.Count - 1 do
  begin
    z:=THVector.CreateFromNode(node.ChildNodes.Get(i));
    vectorlist.Add(z);
  end;
end;

procedure THTeoHod.SaveToNode(node: IXMLNode);
var ch:IXMLNode;
begin
  node.SetAttributeNS('name','',name);
  node.SetAttributeNS('ELTYPE','',elementtype);
//  ch:=node.AddChild('vectorlist');
  vectorlist.Save(node);
end;

{ THNivHod }

constructor THNivHod.Create;
begin

end;

procedure THNivHod.LoadFromNode(node: IXMLNode);
begin

end;

procedure THNivHod.SaveToNode(node: IXMLNode);
begin

end;

initialization
  globalpoints:=THPointList.Create;
end.

