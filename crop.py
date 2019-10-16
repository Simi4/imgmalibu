from PIL import Image
from glob import glob
import xml.etree.ElementTree as ET


N = 100



def get_bndbox(obj):
    xmin = int(obj.findtext('bndbox/xmin'))
    ymin = int(obj.findtext('bndbox/ymin'))
    xmax = int(obj.findtext('bndbox/xmax'))
    ymax = int(obj.findtext('bndbox/ymax'))
    return (xmin, ymin, xmax, ymax)



for i, xml in enumerate(glob('*.xml')):
	img = Image.open(xml.replace('.xml', '.jpg'))
	tree = ET.parse(xml)
	root = tree.getroot()
	for j, obj in enumerate(root.findall('object')):
		area = get_bndbox(obj)
		cropped = img.crop(area)
		resized = cropped.resize((N, N) ,Image.ANTIALIAS)
		resized.save('cropped/{}_{}.jpg'.format(i, j))
