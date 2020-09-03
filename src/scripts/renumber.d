#!/usr/bin/env rdmd


void main(string[] args)
{
	import std.getopt;
	import std.algorithm;
	import std.stdio;
	import biophysics.pdb;

	bool non   = false;
	uint start = 1;
	auto opt = getopt(args,
			  "non_standard|n", "Use non-standard residued", &non,
			  "start|s", "Start at this value", &start);

	if (args.length > 2 || opt.helpWanted) {
		defaultGetoptPrinter("Usage of " ~ args[0] ~ ":", opt.options);
		return;
	}
	auto file = (args.length == 2 ? File(args[1]) : stdin);
	file.parse(non).renumber(start).print;
}