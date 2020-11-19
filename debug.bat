@setlocal enableextensions
@cd /d %*
SET _JAVA_OPTIONS=
SET PZ_CLASSPATH=jinput.jar;lwjgl.jar;lwjgl_util.jar;sqlite-jdbc-3.27.2.1.jar;uncommons-maths-1.2.3.jar;trove-3.0.3.jar;javacord-2.0.17-shaded.jar;guava-23.0.jar;jassimp.jar;./
".\jre64\bin\java.exe" -Ddebug -Dzomboid.steam=1 -Dzomboid.znetlog=1 -XX:+UseConcMarkSweepGC
-XX:-CreateMinidumpOnCrash -XX:-OmitStackTraceInFastThrow -Xms1800m -Xmx2048m -Djava.library.path=./ -cp %PZ_CLASSPATH% zombie.gameStates.MainScreenState
PAUSE
