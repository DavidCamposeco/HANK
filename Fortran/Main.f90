PROGRAM Main

USE Parameters
USE Globals
USE mUMFPACK

CALL SetParameters
IF (CalibrateCostFunction==1) CALL Calibration
CALL InitialSteadyState
CALL SaveSteadyStateOutput
CALL FinalSteadyState
IF(DoImpulseResponses==1) CALL ImpulseResponses

END PROGRAM Main