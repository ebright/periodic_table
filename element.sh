#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
    exit
fi
if [[ $1 =~ ^[0-9]+$ ]] 
  then 
    QUERY_RESULTS=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1;")
    if [[ -z $QUERY_RESULTS ]]
      then
        echo "I could not find that element in the database."
        exit
    fi
    read NAME SYMBOL TYPE MASS MELT BOIL <<< $(echo $QUERY_RESULTS | sed 's/|/ /g')
    echo "The element with atomic number $1 is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    exit
fi
if [[ $1 =~ ^[A-Z][a-z]?$ ]] 
  then 
    QUERY_RESULTS=$($PSQL "SELECT name, atomic_number, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1';")
    if [[ -z $QUERY_RESULTS ]]
      then
        echo "I could not find that element in the database."
        exit
    fi
    read NAME NUMBER TYPE MASS MELT BOIL <<< $(echo $QUERY_RESULTS | sed 's/|/ /g')
    echo "The element with atomic number $NUMBER is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    exit
  else
    QUERY_RESULTS=$($PSQL "SELECT atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE LOWER(name) = LOWER('$1');")
    if [[ -z $QUERY_RESULTS ]]
      then
        echo "I could not find that element in the database."
        exit
    fi
    read NUMBER SYMBOL TYPE MASS MELT BOIL <<< $(echo $QUERY_RESULTS | sed 's/|/ /g')
    echo "The element with atomic number $NUMBER is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    exit
fi