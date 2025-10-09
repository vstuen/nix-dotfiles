from setuptools import setup, find_packages

setup(
    name="vstuen-pyscripts",
    version="0.1",
    # Look for packages inside the src directory.
    package_dir={'': 'src'},
    packages=find_packages(where='src'),
    entry_points={
        'console_scripts': [
            'camelcase=vstuen_pyscripts.camelcase:main',  
            'capitalize=vstuen_pyscripts.capitalize:main',  
            'isodate=vstuen_pyscripts.isodate:main',  
            'mwpwd=vstuen_pyscripts.mwpwd:main',  
            'pwdgen=vstuen_pyscripts.pwdgen:main',  
            'timerequest=vstuen_pyscripts.timerequest:main',  
            'urldecode=vstuen_pyscripts.urldecode:main',  
            'urlencode=vstuen_pyscripts.pwdurlencode:main',  
            'urlq=vstuen_pyscripts.urlq:main',  
            'wftime=vstuen_pyscripts.wftime:main',  
        ]
    },
)
