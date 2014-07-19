############################################################################
############################################################################
##
##
##  Yags: Yet another graph system
##  R. MacKinney, M.A. Pizana and R. Villarroel-Flores
##
##  Version 0.01
##  2003/May/08
##  Graphs, Genetic Algorihms and Groups
##
##  basics.g: Things that GAP forgot to include or I failed to find.
##


############################################################################
##
#F  IsBoolean( <x> )
## 
InstallGlobalFunction(IsBoolean,
function(x) 
  return (x=true or x=false); 
end);


############################################################################
##
#M  DumpObject( <Obj> )
##   
InstallMethod(DumpObject,"for objects",true,[IsObject],0,
function(Obj)
  local x,Attr,Prop,TrueProp;
  Print("Object( ");
    Attr:=KnownAttributesOfObject(Obj);
    Prop:=KnownPropertiesOfObject(Obj);
  Print("TypeObj := ",TypeObj(Obj));
  Print(", Categories := ", CategoriesOfObject(Obj));
  for x in [1..Length(Attr)] do 
    Print(", ");
    Print(Attr[x]," := ",ValueGlobal(Attr[x])(Obj));
  od;
  for x in [1..Length(Prop)] do 
    Print(", ");
    Print(Prop[x]," := ",ValueGlobal(Prop[x])(Obj));
  od;
  Print(" )\n");
end);


############################################################################
##
#F  UFFind( <UFS>, <x> )
## 
InstallGlobalFunction("UFFind",
function(UFS,x)
  local x1,L;
  L:=[];
  if not IsBound(UFS[x]) then 
    UFS[x]:=rec(size:=1,parent:=0); #parent=0 means x is a root. 
  fi;
  while UFS[x].parent<>0 do
     Add(L,x);    #record x for later path compression
     x:=UFS[x].parent;
  od;             #now x is a root vertex.
  for x1 in L do  #path compression, (size may become invalid for non-root vertices)
     UFS[x1].parent:=x;
  od;
  return x;
end);

############################################################################
##
#F  UFUnite( <UFS>, <x>, <y> )
## 
InstallGlobalFunction("UFUnite",
function(UFS,x,y) # returns true if some action actually took place
  x:=UFFind(UFS,x);
  y:=UFFind(UFS,y);
  if x=y then return false; fi;
  if UFS[x].size<UFS[y].size then 
    UFS[x].parent:=y;
    UFS[y].size:=UFS[y].size+UFS[x].size;
    return true;
  fi;
  UFS[y].parent:=x;
  UFS[x].size:=UFS[x].size+UFS[y].size;
  return true;
end);

#E
