(add-to-classpath "java/karel2_c.jar")

(defclass jclass ()
  ((java-class :accessor java-class :initform (error "Must have a java class."))))

(defclass display (jclass)
  ((java-class :initform (jclass "edu.fcps.karel2.Display"))
   (map :accessor display-map :initarg :map)))

(defmethod initialize-instance :after ((display display) &key map)
  (setf (display-map display) map))

(defmethod (setf display-map) (map (display display))
  (let ((method (jmethod (java-class display) "openWorld" (jclass "java.lang.String"))))
    (jcall method nil map)
    (setf (slot-value display 'map) map)))

(defclass robot (jclass)
  ((java-class :initform nil)))

(defmethod initialize-instance :after ((robot robot) &key x y direction beepers)
  (if (and x y direction beepers)
      (setf (java-class robot) (jnew "edu.fcps.karel2.Robot"
                                x y
                                (case direction
                                  (:north 1)
                                  (:south 3)
                                  (:east 0)
                                  (:west 2))
                                beepers))
      (setf (java-class robot) (jnew "edu.fcps.karel2.Robot"))))

(defmethod move ((robot robot) &optional (n 1))
  (loop repeat n do
    (jcall "move" (java-class robot))))

(defmethod take-beeper ((robot robot))
  (jcall "pickBeeper" (java-class robot)))

(defmethod put-beeper ((robot robot))
  (jcall "putBeeper" (java-class robot)))

(defmethod left ((robot robot) &optional (n 1))
  (loop repeat n do
    (jcall "turnLeft" (java-class robot))))
