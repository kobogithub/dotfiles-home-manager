# Dotfiles

Configuración personal usando Nix y Home Manager para gestionar dotfiles y paquetes en sistemas Linux.

## Pre-requisitos

- Git
- Acceso a sudo

## Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/kobogithub/dotfiles-home-manager.git
cd dotfiles-home-manager
```

2. Ejecutar el script de instalación:
```bash
# Dar permisos de ejecución
chmod +x install.sh

# Ejecutar instalación
./install.sh
```

El script realizará automáticamente:
- Instalación de Nix si no está presente
- Instalación de Home Manager
- Creación de enlaces simbólicos necesarios
- Aplicación de la configuración inicial

3. Configurar ZSH como shell predeterminada:
```bash
# Agregar ZSH al archivo de shells válidas
echo $(which zsh) | sudo tee -a /etc/shells

# Cambiar la shell predeterminada
chsh -s $(which zsh)
```

4. Aplicar los cambios:
- Cierra sesión y vuelve a entrar, o
- Reinicia tu terminal

## Estructura del Repositorio

```
dotfiles/
├── install.sh              # Script de instalación
├── home-manager/
│   ├── home.nix           # Configuración principal
│   └── modules/           # Módulos de configuración
│       ├── git.nix        # Configuración de Git
│       └── zsh.nix        # Configuración de ZSH
```

## Verificación

Para verificar que todo está funcionando correctamente:

1. Comprobar que ZSH está activa:
```bash
echo $SHELL
# Debería mostrar: /home/TU_USUARIO/.nix-profile/bin/zsh
```

2. Verificar la instalación de Home Manager:
```bash
home-manager --version
```

## Actualizaciones

Para actualizar tu configuración:

```bash
# Actualizar el repositorio
cd ~/dotfiles
git pull

# Aplicar cambios
home-manager switch
```

## Problemas Comunes

1. Si ZSH no aparece como shell válida:
```bash
# Verificar la ruta de ZSH
which zsh

# Agregar manualmente a /etc/shells si es necesario
echo $(which zsh) | sudo tee -a /etc/shells
```

2. Si Home Manager no encuentra la configuración:
```bash
# Verificar el enlace simbólico
ls -la ~/.config/home-manager
```

## Contribuir

1. Haz fork del repositorio
2. Crea una rama para tu feature: `git checkout -b feature/nueva-caracteristica`
3. Commit tus cambios: `git commit -am 'Agregar nueva característica'`
4. Push a la rama: `git push origin feature/nueva-caracteristica`
5. Envía un Pull Request

## Licencia

Este proyecto está licenciado bajo MIT License - ve el archivo LICENSE para más detalles.
