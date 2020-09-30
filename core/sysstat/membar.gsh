#!/bin/bash

if ! _:ginger_bin then ; then return 1; fi
if ! _:ginger_bin grep ; then return 1; fi
if ! _:ginger_bin awk ; then return 1; fi

_physical_free=$( free | grep Mem: | awk '{print ($5+$4)/$2*100}' | cut -f 1 -d '.' )
_physical_used=$( free | grep Mem: | awk '{print (1-(($5+$4)/$2))*100}' | cut -f 1 -d '.' )

if [ $(free | grep Swap: | awk '{print ($4)}') -gt 0 ]
then
	_swap_free=$( free | grep Swap: | awk '{print ($4)/$2*100}' | cut -f 1 -d '.' )
	_swap_used=$( free | grep Swap: | awk '{print (1-($4/$2))*100}' | cut -f 1 -d '.' )
else
	_swap_free="NOT AVAILABLE"
	_swap_used="NOT AVAILABLE"
fi

memstat()
{
  echo -n pu: ${_physical_used}
  _:ginger_simple_bar ${_physical_used}
  echo -n pf: ${_physical_free}
  _:ginger_simple_bar ${_physical_free}
  echo -n su: ${_swap_used}
  _:ginger_simple_bar ${_swap_used}
  echo -n sf: ${_swap_free}
  _:ginger_simple_bar ${_swap_free}
}
