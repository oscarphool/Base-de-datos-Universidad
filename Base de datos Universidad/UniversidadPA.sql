-- Procedimiento almacenados
-- Villena Rojas Oscar Phool
-- 10/08/22

--PA para Escuelas

use BDUniversidad
go

-- /////////////////////////////////////////////////////////////////////////////////////////////////////
if OBJECT_ID('spListarEscuela') is not null
	drop proc splistarEscuela
go
create proc spListarEscuela
as
begin
	select CodEscuela, Escuela, Facultad from TEscuela
end
go

exec spListarEscuela
go
-- -----------------------------------------------------------------------------------------------------
if OBJECT_ID('spListarAlumnos') is not null
	drop proc spListarAlumnos
go
create proc spListarAlumnos
as
begin
	select CodAlumno, Apellidos, Nombres, LugarNac, FechaNac, CodEscuela from TAlumno
end
go

exec spListarAlumnos
go
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
if OBJECT_ID('spAgregarEscuela') is not null
	drop proc spAgregarEscuela
go
create proc spAgregarEscuela
@CodEscuela char(3), @Escuela varchar(50), @Facultad varchar(50)
as begin
	--CodEscuela  no puede ser duplicado
	if not exists(select CodEscuela from TEscuela where CodEscuela=@CodEscuela)
	--Escuela no puede ser duplicado
		if not exists (select Escuela from TEscuela where Escuela=@Escuela)
		begin
			insert into TEscuela values(@CodEscuela,@Escuela,@Facultad)
			select CodError = 0, Mensaje = 'Se inserto correctamente escuela'
		end
		else select CodError = 1, Mensaje = 'Error: Escuela duplicada'
	else select CodError = 1, Mensaje = 'Error: CodEscuela duplicado'
end
go

exec spAgregarEscuela @CodEscuela = 'E06', @Escuela = 'Derechoo', @Facultad = 'CEACC';
go
select * from TEscuela
-- -----------------------------------------------------------------------------------------------------
if OBJECT_ID('spAgregarAlumno') is not null
	drop proc spAgregarAlumno
go
create proc spAgregarAlumno
@CodAlumno char(5), @Apellidos varchar(50), @Nombres varchar(50), @LugarNac varchar(50), @FechaNac datetime, @CodEscuela char(3)
as begin
	--CodAlumno  no puede ser duplicado
	if not exists(select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
	--Escuela debe existir
		if exists (select Escuela from TEscuela where CodEscuela=@CodEscuela)
		begin
			insert into TAlumno values(@CodAlumno,@Apellidos,@Nombres,@LugarNac,@FechaNac,@CodEscuela)
			select CodError = 0, Mensaje = 'Se inserto correctamente nuevo alumno'
		end
		else select CodError = 1, Mensaje = 'Error: Escuela no existe'
	else select CodError = 1, Mensaje = 'Error: CodAlumno duplicado'
end

go

exec spAgregarAlumno @CodAlumno = 'A0001', @Apellidos = 'Hurtadpo Bellojta', @Nombres = 'Juanb Washingtong', @LugarNac = 'Cuscol', @FechaNac = '2000-11-11 13:23:44', @CodEscuela = 'E06';
go

select * from TAlumno
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
-- Actividad Implementar Eliminar, Actualizar y Buscar
-- Presentado para el dia miecoles 10 de agosto a traves de Aula Virtual
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
if OBJECT_ID('spEliminarEscuela') is not null
	drop proc spEliminarEscuela
go
create proc spEliminarEscuela
@CodEscuela char(3)
as begin
	--Comprobamos que no hayan alumnos en la EP
	if not exists (select * from TAlumno where CodEscuela=@CodEscuela)
		begin
			--CodEscuela debe existir
			if exists(select CodEscuela from TEscuela where CodEscuela=@CodEscuela)
				begin
					delete from TEscuela where CodEscuela=@CodEscuela
					delete from TEscuela where CodEscuela='E06'
					select CodError = 0, Mensaje = 'Se elimino correctamente escuela'
				end
			else select CodError = 1, Mensaje = 'Error: CodEscuela no existe'
		end
	else select CodError = 1, Mensaje = 'Error: No se puede borrar la EP, hay alumnos vinculados a la EP'
end
go

exec spEliminarEscuela @CodEscuela = 'E06';
go

select * from TEscuela
-- -----------------------------------------------------------------------------------------------------
if OBJECT_ID('spEliminarAlumno') is not null
	drop proc spEliminarAlumno
go
create proc spEliminarAlumno
@CodAlumno char(5)
as begin
	--CodAlumno debe existir
	if exists(select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		begin
			delete from TAlumno where CodAlumno=@CodAlumno
			select CodError = 0, Mensaje = 'Se elimino correctamente alumno'
		end
	else select CodError = 1, Mensaje = 'Error: CodAlumno no existe'
end
go

exec spEliminarAlumno @CodAlumno = 'A0001';
go
select * from TAlumno
select * from TEscuela
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
-- Actualizar
if OBJECT_ID('spActualizarEscuela') is not null
	drop proc spActualizarEscuela
go
create proc spActualizarEscuela
@CodEscuela char(3), @Escuela varchar(50), @Facultad varchar(50)
as begin
	--CodEscuela debe existir
	if exists(select CodEscuela from TEscuela where CodEscuela=@CodEscuela)
		begin
			update TEscuela set Escuela = @Escuela, Facultad = @Facultad where CodEscuela = @CodEscuela
			select CodError = 0, Mensaje = 'Se actualizo correctamente escuela'
		end
	else select CodError = 1, Mensaje = 'Error: CodEscuela no existe'
end
go

exec spActualizarEscuela @CodEscuela = 'E06', @Escuela = 'Derecho', @Facultad = 'CEAC';
go

select * from TEscuela
-- -----------------------------------------------------------------------------------------------------
if OBJECT_ID('spActualizarAlumno') is not null
	drop proc spActualizarAlumno
go
create proc spActualizarAlumno
@CodAlumno char(5), @Apellidos varchar(50), @Nombres varchar(50), @LugarNac varchar(50), @FechaNac datetime, @CodEscuela char(3)
as begin
	--CodAlumno debe existir
	if exists(select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		begin
			update TAlumno set Apellidos = @Apellidos, Nombres = @Nombres, LugarNac = @LugarNac, FechaNac = @FechaNac, CodEscuela = @CodEscuela where CodEscuela = @CodEscuela
			select CodError = 0, Mensaje = 'Se actualizo correctamente alumno'
		end
	else select CodError = 1, Mensaje = 'Error: CodAlumno no existe'
end
go

exec spActualizarAlumno @CodAlumno = 'A0001', @Apellidos = 'Hurtado Bellota', @Nombres = 'Juan Washington', @LugarNac = 'Cusco', @FechaNac = '2000-11-11 13:23:44', @CodEscuela = 'E06';
go
select * from TAlumno
-- /////////////////////////////////////////////////////////////////////////////////////////////////////
-- Buscar
if OBJECT_ID('spBuscarEscuela') is not null
	drop proc spBuscarEscuela
go
create proc spBuscarEscuela
@CodEscuela char(3)
as begin
	--CodEscuela debe existir
	if exists(select CodEscuela from TEscuela where CodEscuela=@CodEscuela)
		begin
			select * from TEscuela where CodEscuela=@CodEscuela
			select CodError = 0, Mensaje = 'Se encontro correctamente escuela'
		end
	else select CodError = 1, Mensaje = 'Error: CodEscuela no existe'
end
go

exec spBuscarEscuela @CodEscuela = 'E06';
go
-- -----------------------------------------------------------------------------------------------------
if OBJECT_ID('spBuscarAlumno') is not null
	drop proc spBuscarAlumno
go
create proc spBuscarAlumno
@CodAlumno char(5)
as begin
	--CodEscuela debe existir
	if exists(select CodAlumno from TAlumno where CodAlumno=@CodAlumno)
		begin
			select * from TAlumno where CodAlumno=@CodAlumno
			select CodError = 0, Mensaje = 'Se encontro correctamente alumno'
		end
	else select CodError = 1, Mensaje = 'Error: CodAlumno no existe'
end
go

exec spBuscarAlumno @CodAlumno = 'A0001';
go