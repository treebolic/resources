
function select(tag)
{
		var maindoc=document;
		var all=maindoc.getElementsByName('relation');
		for(i=0;i<all.length;i++)
		{
			var e=all[i];
			e.style.display='none';
		}
		var e=maindoc.getElementById(tag);
		e.style.display='block';
}
function menu()
{
		var maindoc=document;
		var toc=maindoc.getElementById('toc');
		if((toc.style.display != 'inline'))
			toc.style.display='inline';
		else
			toc.style.display='none';
}
