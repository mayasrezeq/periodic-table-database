#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

# إذا لم يتم إدخال أي وسيط
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# البحث عن العنصر (سواء كان رقم ذري، رمز، أو اسم)
ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")

# إذا لم يتم العثور على العنصر
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# طباعة المعلومات
echo "$ELEMENT" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME MASS MELTING BOILING TYPE
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
done

