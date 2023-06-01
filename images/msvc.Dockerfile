ARG ROOT_IMAGE

FROM $ROOT_IMAGE

ARG MSVC_VER
ARG MSVC_COMPILER_VER

RUN /tools/install-compiler.ps1 -msvcVersion $ENV:MSVC_VER -clversion $ENV:MSVC_COMPILER_VER
