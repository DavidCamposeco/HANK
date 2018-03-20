SUBROUTINE dfovec(n,m,x,f)
!objective function for DFLS minimization
!output f vector of least squares objective

USE Parameters
USE Globals
USE Procedures

IMPLICIT NONE

INTEGER, INTENT(IN)		:: m,n
REAL(8), INTENT(IN)		:: x(n)
REAL(8), INTENT(OUT)	:: f(m)
REAL(8)					:: lp(4),lweight(m),lf
INTEGER					:: im,ip

objeval = objeval+1
write(4,*) '*********************************'
write(4,*) 'EVALUATION NUMBER: ',objeval

!untransform paramaters and create full parameter vector
ip = 0
IF(EstimateY1width==1) THEN
	ip = ip+1
	lp(1) = y1widthmin + (y1widthmax-y1widthmin)*logistic(x(ip))	
	write(4,*) ' y1width: ',lp(1)	
ELSE
	lp(1) = y1widthguess
END IF
IF(EstimateY2width==1) THEN
	ip = ip+1
	lp(2) = y2widthmin + (y2widthmax-y2widthmin)*logistic(x(ip))	
	write(4,*) ' y2width: ',lp(2)	
ELSE
	lp(2) = y2widthguess
END IF
IF(EstimateY1GridPar==1) THEN
	ip = ip+1
	lp(3) = y1gridmin + (1.0-y1gridmin)*logistic(x(ip))
	write(4,*) ' y1gridpar: ',lp(3)		
ELSE IF(DefaultY1GridPar1) THEN
	lp(3) = 1.0
ELSE
	lp(3) = y1gridparguess
END IF
IF(EstimateY2GridPar==1) THEN
	ip = ip+1
	lp(4) = logistic(x(ip))
	lp(4) = y2gridmin + (1.0-y2gridmin)*logistic(x(ip))
	
	write(4,*) ' y2gridpar: ',lp(4)
ELSE IF(DefaultY2GridPar1) THEN
	lp(4) = 1.0
ELSE
	lp(4) = y2gridparguess
END IF


CALL TransitionMatrix(lp,y1grid,y1markov,y1dist,y2grid,y2markov,y2dist)
CALL Simulate
CALL ComputeMoments

lweight = 1.0
im = 0
IF (MatchVarLogY == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(mu2y/TargetVarLogY -1.0)
	write(4,*) ' VarLogY, target: ',TargetVarLogY, ' model: ',mu2y	
END IF	
IF (MatchVarD1LogY == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(mu2dy1/TargetVarD1LogY -1.0)
	write(4,*) ' VarD1LogY, target: ',TargetVarD1LogY, ' model: ',mu2dy1
END IF	
IF (MatchSkewD1LogY == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(gam3dy1/TargetSkewD1LogY -1.0)
	write(4,*) ' SkewD1LogY, target: ',TargetSkewD1LogY, ' model: ',gam3dy1
END IF	
IF (MatchKurtD1LogY == 1) THEN
	im = im +1
	lweight(im) = 0.5
	f(im) = sqrt(lweight(im))*(gam4dy1/TargetKurtD1LogY -1.0)
	write(4,*) ' KurtD1LogY, target: ',TargetKurtD1LogY, ' model: ',gam4dy1
END IF	
IF (MatchVarD5LogY == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(mu2dy5/TargetVarD5LogY -1.0)
	write(4,*) ' VarD5LogY, target: ',TargetVarD5LogY, ' model: ',mu2dy5
END IF	
IF (MatchSkewD5LogY == 1) THEN
	im = im +1
	lweight(im) = 0.5	
	f(im) = sqrt(lweight(im))*(gam3dy5/TargetSkewD5LogY -1.0)
	write(4,*) ' VarSkewD5LogY, target: ',TargetSkewD5LogY, ' model: ',gam3dy5
END IF	
IF (MatchKurtD5LogY == 1) THEN
	im = im +1
	lweight(im) = 0.5
	f(im) = sqrt(lweight(im))*(gam4dy5/TargetKurtD5LogY -1.0)
	write(4,*) ' KurtD5LogY, target: ',TargetKurtD5LogY, ' model: ',gam4dy5
END IF	
IF (MatchFracD1Less5 == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(fracdy1less5/TargetFracD1Less5 -1.0)
	write(4,*) ' FracD1Less5, target: ',TargetFracD1Less5, ' model: ',fracdy1less5
END IF	
IF (MatchFracD1Less10 == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(fracdy1less10/TargetFracD1Less10 -1.0)
	write(4,*) ' FracD1Less10, target: ',TargetFracD1Less10, ' model: ',fracdy1less10
END IF	
IF (MatchFracD1Less20 == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(fracdy1less20/TargetFracD1Less20 -1.0)
	write(4,*) ' FracD1Less20, target: ',TargetFracD1Less20, ' model: ',fracdy1less20
END IF	
IF (MatchFracD1Less50 == 1) THEN
	im = im +1
	f(im) = sqrt(lweight(im))*(fracdy1less50/TargetFracD1Less50 -1.0)
	write(4,*) ' FracD1Less50, target: ',TargetFracD1Less50, ' model: ',fracdy1less50
END IF	

lweight = lweight/sum(lweight)

lf = sqrt(sum((f**2.0)*lweight)/sum(lweight))
write(4,*) ' objective fun: ',lf
write(4,*) ' '


END SUBROUTINE dfovec