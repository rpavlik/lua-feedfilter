if not SILENT then
	return function(...) print(...) end
else
	return function(...) end
end
