#!/usr/bin/env dub
/+ dub.sdl:
	name        "translate"
	targetType  "executable"
	targetPath  "../bin"
	targetName  "translate"
	dependency "biophysics" version="*" path=".."
+/

/* Copyright (C) 2020 Andreas Füglistaler <andreas.fueglistaler@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

module tools.translate;

import std.algorithm;
import biophysics.pdb;

auto translate(Range)(Range atoms, double[3] vec, string chain) {
	import std.math;

	return atoms.map!((atom) {
		if (!chain.canFind(atom.chainID)) return atom;

		if (!vec[0].isNaN) atom.x = atom.x + vec[0];
		if (!vec[1].isNaN) atom.y = atom.y + vec[1];
		if (!vec[2].isNaN) atom.z = atom.z + vec[2];
		return atom;
	});
}

immutable description=
"Translate chains of PDB-FILE in x, y, z and write to standard output.";

void main(string[] args) {
	import std.getopt;
	import std.stdio;

	bool non = false;
	double x,y,z;
	string chains = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	auto opt = getopt(
		args,
		"hetatm|n", "Use non-standard (HETATM) residues", &non,
		"x", "x-value [A]", &x,
		"y", "y-value [A]", &y,
		"z", "z-value [A]", &z,
		"chains|c", "Chains to translate, default = all", &chains);

	if (args.length > 2 || opt.helpWanted) {
		defaultGetoptPrinter(
			"Usage: " ~ args[0]
			~ " [OPTIONS]... [FILE]\n"
			~ description
			~ "\n\nWith no FILE, or when FILE is --,"
			~ " read standard input.\n",
			opt.options);
		return;
	}
	auto file = (args.length == 2 ? File(args[1]) : stdin);

	file.parse(non).translate([x, y, z], chains).print;
}
