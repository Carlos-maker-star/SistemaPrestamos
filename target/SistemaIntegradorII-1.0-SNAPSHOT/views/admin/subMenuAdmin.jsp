<%-- 
    Document   : subMenuAdmin
    Created on : 28 mar. 2025, 12:30:57
    Author     : CARLOS RIVADENEYRA
--%>

<nav class="topnav navbar navbar-light">
    <form class="form-inline mr-auto searchform text-muted">
        <input class="form-control mr-sm-2 bg-transparent border-0 pl-4 text-muted" type="search" placeholder="Buscar..." aria-label="Search">
    </form>
    <ul class="nav">
        <li class="nav-item">
            <a class="nav-link text-muted my-2" href="#" id="modeSwitcher" data-mode="light">
                <i class="fe fe-sun fe-16"></i>
            </a>
        </li>
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle text-muted pr-0" href="#" id="navbarDropdownMenuLink" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <span class="avatar avatar-sm mt-2">
                    <img src="<%=request.getContextPath()%>/assets/img/leon.jpg" alt="..." class="avatar-img rounded-circle">
                </span>
            </a>
            <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                <a class="dropdown-item" href="perfilAdmin.jsp">Perfil</a>
                <a class="dropdown-item" href="<%=request.getContextPath()%>/CerrarSesionServlet">Cerrar Sesion</a>
            </div>
        </li>
    </ul>
</nav>
<aside class="sidebar-left border-right bg-white shadow" id="leftSidebar" data-simplebar>
    <div class="text-center mt-3">
        <h4 class="font-weight-bold mt-4 mb-2">ADMINISTRADOR</h4>
        <a href="indexAdmin.jsp"><img src="<%=request.getContextPath()%>/assets/img/Logo_Empresa_CARMIC.png" class="img-icon pt-2"></a>
    </div>
    <a href="#" class="btn collapseSidebar toggle-btn d-lg-none text-muted ml-2 mt-3" data-toggle="toggle">
        <i class="fe fe-x"><span class="sr-only"></span></i>
    </a>
    <nav class="vertnav navbar navbar-light">
        <!-- nav bar -->
        <p class="text-muted nav-heading mt-4 mb-1">
            <span>Inicio</span>
        </p>
        <ul class="navbar-nav flex-fill w-100 mb-2">
            <li class="nav-item w-100">
                <a class="nav-link" href="<%=request.getContextPath()%>/UsuarioServlet?accion=listarUsuarios">
                    <i class="fe fe-user fe-16"></i>
                    <span class="ml-3 item-text">Clientes</span>
                </a>
                <a class="nav-link" href="<%=request.getContextPath()%>/PrestamoServlet?accion=listarPrestamos">
                    <i class="fe fe-user fe-16"></i>
                    <span class="ml-3 item-text">Prestamos</span>
                </a>
            </li>
        </ul>
    </nav>
</aside>