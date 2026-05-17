package com.washtrack.washtrack_api.util.constantes;

public final class ConstantesBaseDatos {
  
  private ConstantesBaseDatos() {
  }
  
  // BASES DE DATOS
  public static final String WASHTRACKDB = "washtrackdb";
  
  // STORED PROCEDURES ORDENES
  public static final String SP_LISTAR_ORDENES = "SP_LISTAR_ORDENES";
  public static final String SP_INSERTAR_ORDENSERVICIO = "SP_INSERTAR_ORDENSERVICIO";
  public static final String SP_LISTARPOR_FECHAINGRESO = "SP_LISTARPOR_FECHAINGRESO";
  public static final String SP_BUSCAR_ORDENSERVICIO = "SP_BUSCAR_ORDENSERVICIO";
  public static final String SP_ACTUALIZAR_ORDENSERVICIO = "SP_ACTUALIZAR_ORDENSERVICIO";
  public static final String SP_ELIMINAR_ORDENSERVICIO = "SP_ELIMINAR_ORDENSERVICIO";
  
  // SP DETALLE ORDEN SERVICIO
  public static final String SP_BUSCAR_DETALLEORDEN = "SP_BUSCAR_DETALLEORDEN";
  public static final String SP_BUSCAR_ORDENSERVICIOCONDETALLE = "SP_BUSCAR_ORDENSERVICIOCONDETALLE";
  public static final String SP_INSERTAR_DETALLEORDEN = "SP_INSERTAR_DETALLEORDEN";
  public static final String SP_ACTUALIZAR_DETALLEORDEN = "SP_ACTUALIZAR_DETALLEORDEN";
  public static final String SP_ELIMINAR_DETALLEORDEN = "SP_ELIMINAR_DETALLEORDEN";
  
  // SP CLIENTES
  public static final String SP_LISTAR_CLIENTES = "SP_LISTAR_CLIENTES";
  public static final String SP_BUSCAR_CLIENTE = "SP_BUSCAR_CLIENTE";
  public static final String SP_INSERTAR_CLIENTE = "SP_INSERTAR_CLIENTE";
  public static final String SP_ACTUALIZAR_CLIENTE = "SP_ACTUALIZAR_CLIENTE";
  public static final String SP_ELIMINAR_CLIENTE = "SP_ELIMINAR_CLIENTE";
  
  // SP USUARIOS
  public static final String SP_LOGIN_USUARIO = "SP_LOGIN_USUARIO";
  public static final String SP_BUSCAR_USUARIO_ID = "SP_BUSCAR_USUARIO_ID";
  public static final String SP_LISTAR_USUARIOS = "SP_LISTAR_USUARIOS";
  public static final String SP_INSERTAR_USUARIO = "SP_INSERTAR_USUARIO";
  public static final String SP_ELIMINAR_USUARIO = "SP_ELIMINAR_USUARIO";
  public static final String SP_REACTIVAR_USUARIO = "SP_REACTIVAR_USUARIO";
  public static final String SP_ACTUALIZAR_USUARIO = "SP_ACTUALIZAR_USUARIO";
  public static final String SP_BUSCAR_USUARIO_EMAIL = "SP_BUSCAR_USUARIO_EMAIL";
  
  // SP PROCESOS
  public static final String SP_INSERTAR_PROCESO = "SP_INSERTAR_PROCESO";
  public static final String SP_ACTUALIZAR_PROCESO = "SP_ACTUALIZAR_PROCESO";
  public static final String SP_ELIMINAR_PROCESO = "SP_ELIMINAR_PROCESO";
  public static final String SP_BUSCAR_PROCESO = "SP_BUSCAR_PROCESO";
  public static final String SP_LISTAR_PROCESOS = "SP_LISTAR_PROCESOS";
  
  // ENTREGAS
  public static final String SP_LISTAR_ENTREGAS = "SP_LISTAR_ENTREGAS";
  public static final String SP_INSERTAR_ENTREGA = "SP_INSERTAR_ENTREGA";
  public static final String SP_ACTUALIZAR_ENTREGA = "SP_ACTUALIZAR_ENTREGA";
  public static final String SP_BUSCAR_ENTREGA = "SP_BUSCAR_ENTREGA";
  public static final String SP_ELIMINAR_ENTREGA = "SP_ELIMINAR_ENTREGA";
  
  // DASHBOARD
  public static final String SP_DASHBOARD = "SP_DASHBOARD";
  
  // OUT BD
  public static final String CODIGOBD = "pa_codigobd";
  public static final String PAMENSAJEBD = "pa_mensaje";
  
}
