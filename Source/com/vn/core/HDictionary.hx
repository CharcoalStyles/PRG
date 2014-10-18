package com.vn.core;

class HDictionary {
	private var _map 	: List<Pair>;
	
	public function new() {
		_map  = new List<Pair>();
	}
	
	private function getPair(key: Dynamic): Pair {
		for (p in _map) {
			if (p.key == key) return p;
		}
		return null;
	}
	
	/*******************************
	 * 		PUBLIC APIS
	 ******************************/
	
	public function hasKey(key: Dynamic): Bool {
		var p = getPair(key);
		return p != null;
	}
	
	public function deleteKey(key: Dynamic): Void {
		var p = getPair(key);
		if (p != null) _map.remove(p);
	}
	
	public function getValue(key: Dynamic): Dynamic {
		var p = getPair(key);
		return p == null ? null : p.value;
	}
	
	public function setKey(key: Dynamic, value: Dynamic, checkExistance: Bool = true): Void {
		if (!checkExistance) {//prevent looking up overhead
			_map.push( { key: key, value: value} );
		} else {
			var o = getPair(key);
			if (o != null) {//modify value if key already exist
				o.value = value;
			} else {//create new Pair if key not yet exist
				_map.push( { key: key, value: value} );
			}
		}
	}
}

typedef Pair = { key: Dynamic, value: Dynamic }