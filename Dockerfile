# Use the latest Windows Server Core image.
FROM mcr.microsoft.com/windows/servercore:ltsc2019 as build

# Download useful tools to C:\Bin.
ADD https://dist.nuget.org/win-x86-commandline/v4.1.0/nuget.exe C:\\Bin\\nuget.exe

# Download the Build Tools bootstrapper outside of the PATH.
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\\TEMP\\vs_buildtools.exe

# Add C:\Bin to PATH and install Build Tools excluding workloads and components with known issues.
RUN setx /m PATH "%PATH%;C:\Bin" 
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache --installPath C:\BuildTool \
    --add Microsoft.VisualStudio.Workload.WebBuildTools;includeRecommended \
    --add Microsoft.VisualStudio.Workload.MSBuildTools \
 || IF "%ERRORLEVEL%"=="3010" EXIT 0

ADD https://download.microsoft.com/download/9/0/1/901B684B-659E-4CBD-BEC8-B3F06967C2E7/NDP471-DevPack-ENU.exe C:\\TEMP\\NDP471-DevPack-ENU.exe
RUN C:\TEMP\NDP471-DevPack-ENU.exe /install /quiet /norestart

# Default to PowerShell if no other command specified.
CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
