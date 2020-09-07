#!/usr/bin/env rdmd

/* Copyright (C) 2020 Andreas Füglistaler <andreas.fueglistaler@gmail.com>
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/. */

module tools.renumber;

import std.algorithm;
import biophysics.pdb;

auto renumber(Range)(lazy Range atoms, uint start=1) {
	import std.stdio;
	import std.range;

	uint old_number = 0;
	start--;

	return atoms.map!((atom) {
		if (atom.resSeq != old_number) {
			old_number = atom.resSeq;
			start++;
		}
		atom.resSeq = start;
		return atom;
	});
}

immutable description=
"Renumber residues from PDB-FILE, starting at start, to standard output.";

void main(string[] args)
{
	import std.getopt;
	import std.stdio;

	bool non   = false;
	uint start = 1;

	auto opt = getopt(
		args,
		"hetatm|n", "Use non-standard (HETATM) residues", &non,
		"start|s", "Start at this value", &start);

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
	file.parse(non).renumber(start).print;
}
