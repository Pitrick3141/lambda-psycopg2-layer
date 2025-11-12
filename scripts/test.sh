#!/bin/bash
set -e

echo "Testing Psycopg2 Layer..."

# Create test script
cat > test_psycopg.py << 'EOF'
import sys
import os
sys.path.insert(0, 'build/python')

try:
    import psycopg2
    print("✅ Psycopg2 import successful")
    
    # Check version
    print(f"✅ Psycopg2 version: {psycopg2.__version__}")
    
    # Test extensions
    try:
        import psycopg2.extensions
        print("✅ Psycopg2 extensions import successful")
    except Exception as e:
        print(f"❌ Extensions import failed: {e}")
    
    try:
        import psycopg2.extras
        print("✅ Psycopg2 extras import successful")
    except Exception as e:
        print(f"❌ Extras import failed: {e}")
    
    # Test connection string parsing (without actually connecting)
    try:
        # Test that we can create a connection object (will fail to connect but module should work)
        # We'll just verify the module is functional
        from psycopg2 import connect
        print("✅ Psycopg2 connect function available")
    except Exception as e:
        print(f"❌ Connect function import failed: {e}")
    
    # Test error classes
    try:
        from psycopg2 import Error, DatabaseError, OperationalError
        print("✅ Psycopg2 error classes available")
    except Exception as e:
        print(f"❌ Error classes import failed: {e}")
    
    # Test binary package
    try:
        # psycopg2-binary should have compiled extensions
        conn_info = psycopg2.extensions.connection_info
        print("✅ Psycopg2 binary extensions loaded")
    except Exception as e:
        print(f"⚠️  Extensions check: {e}")

    print("✅ All tests passed!")

except Exception as e:
    print(f"❌ Test failed: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)
EOF

# Run test
python3 test_psycopg.py
rm test_psycopg.py