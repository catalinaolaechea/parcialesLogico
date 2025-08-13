%primeraMarca(Marca) 
primeraMarca(laSerenisima). 
primeraMarca(gallo). 
primeraMarca(vienisima). 
%precioUnitario(Producto,Precio) 
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchicas(Marca,Cantidad) 
precioUnitario(arroz(gallo),25.10). 
precioUnitario(lacteo(laSerenisima,leche), 6.00). 
precioUnitario(lacteo(laSerenisima,crema), 4.00). 
precioUnitario(lacteo(gandara,queso(gouda)), 13.00). 
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50). 
precioUnitario(salchichas(vienisima,12), 9.80). 
precioUnitario(salchichas(vienisima, 6), 5.80). 
precioUnitario(salchichas(granjaDelSol, 8), 5.10). 
%descuento(Producto, Descuento) 
descuento(lacteo(laSerenisima,leche), 0.20). 
descuento(lacteo(laSerenisima,crema), 0.70). 
descuento(lacteo(gandara,queso(gouda)), 0.70). 
descuento(lacteo(vacalin,queso(mozzarella)), 0.05). 
%compro(Cliente,Producto,Cantidad) 
compro(juan,lacteo(laSerenisima,crema),2).

marca(arroz(Marca),Marca).
marca(lacteo(Marca,_), Marca).
marca(salchichas(Marca,_),Marca).

duenio(laSerenisima, gandara). 
duenio(gandara, vacalín). 

descuento(arroz(Marca),1.50):-
    precioUnitario(arroz(Marca),_).

descuento(salchichas(Marca,Cantidad),0.50):-
    precioUnitario(salchichas(Marca, Cantidad), _),
    Marca \= vienisima.

descuento(lacteo(Marca,leche),2):-
    precioUnitario(lacteo(Marca,leche), _).

descuento(lacteo(Marca,queso(Tipo)),2):-
    precioUnitario(lacteo(Marca,queso(Tipo)), _),
    primeraMarca(Marca).

descuento(Producto,0.05):-
    precioUnitario(Producto,MayorPrecio),
    forall(precioUnitario(OtroProducto,_),(precioUnitario(OtroProducto,OtroPrecio), OtroPrecio < MayorPrecio)).

esCompradorCompulsivo(Cliente):-
    compro(Cliente,_,_),
    forall((precioUnitario(Producto, _ ),marca(Producto,Marca),primeraMarca(Marca),descuento(Producto,_)),compro(Cliente,Producto,_)).
    %forall((marca(Producto,Marca),primeraMarca(Marca),descuento(Producto,_)),compro(Cliente,Producto,_)).

totalAPagar(Cliente,Total):-
    compro(Cliente,_,_),
    findall(Precio,(compro(Cliente,Producto,Cantidad),precio(Producto,Cantidad,Precio)),Precios),
    sum_list(Precios, Total).
    

precio(Producto,Cantidad,Precio):-
    descuento(Producto,Descuento),
    precioUnitario(Producto,PrecioUnitario),
    Precio is Cantidad * (PrecioUnitario - Descuento).

precio(Producto,Cantidad,Precio):-
    precioUnitario(Producto,PrecioUnitario),
    not(descuento(Producto,_)),
    Precio is Cantidad * PrecioUnitario.

clienteFiel(Cliente,Marca):-
    compro(Cliente,ProductoX,_), 
    marca(ProductoX,Marca),
    not(
        (
            compro(Cliente, ProductoO, _),
            marca(ProductoO,OtraMarca),
            OtraMarca \= Marca,
            mismoTipoProducto(ProductoO,ProductoX)
        )
    ).


mismoTipoProducto(arroz(_), arroz(_)).
mismoTipoProducto(lacteo(_, Tipo), lacteo(_, Tipo)).
mismoTipoProducto(salchichas(_, Cantidad), salchichas(_, Cantidad)).

